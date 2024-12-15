//
//  PrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public protocol PrefMacro: AccessorMacro, PeerMacro {
    static var keyStructName: String { get }
    static var defaultedKeyStructName: String { get }
    static var hasCustomCoding: Bool { get }
    static var hasInlineCoding: Bool { get }
}

extension PrefMacro /* : AccessorMacro */ {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let varDec = declaration.as(VariableDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        
        guard varDec.bindingSpecifier.tokenKind == .keyword(.var) else {
            throw PrefMacroError.notVarDeclaration
        }
        
        // bypass this, because we want to allow access level attributes.
        // TODO: see if we can filter out access level attributes while throwing an error on other attributes
        // guard varDec.modifiers.isEmpty else {
        //     throw PrefMacroError.modifiersNotAllowed
        // }
        
        let varName = try varName(from: varDec)
        let privateKeyVarName = "\(privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let keyPath = #"\."# + varName.description
        
        let hasDefault = (try? self.defaultValue(from: varDec)) != nil
        
        return [
            """
            get {
                _$observationRegistrar.access(self, keyPath: \(raw: keyPath))
                switch storageMode {
                case .cachedReadStorageWrite:
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = storage.value(forKey: \(raw: privateKeyVarName))
                    }
                    return \(raw: privateValueVarName)\(raw: hasDefault ? " ?? \(privateKeyVarName).defaultValue" : "")
                case .storageOnly:
                    return storage.value(forKey: \(raw: privateKeyVarName))
                }
            }
            """,
            """
            set {
                withMutation(keyPath: \(raw: keyPath)) {
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: newValue)
                    if storageMode == .cachedReadStorageWrite {
                        \(raw: privateValueVarName) = newValue
                    }
                }
            }
            """,
            """
            _modify {
                access(keyPath: \(raw: keyPath))
                _$observationRegistrar.willSet(self, keyPath: \(raw: keyPath))
                defer {
                    _$observationRegistrar.didSet(self, keyPath: \(raw: keyPath))
                }
                switch storageMode {
                case .cachedReadStorageWrite:
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = storage.value(forKey: \(raw: privateKeyVarName))
                    }
                    yield &\(raw: privateValueVarName)\(raw: hasDefault ? "!" : "")
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: \(raw: privateValueVarName))
                case .storageOnly:
                    var val = storage.value(forKey: \(raw: privateKeyVarName))
                    yield &val
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: val)
                }
            }
            """
        ]
    }
}

extension PrefMacro /* : PeerMacro */ {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let varDec = declaration.as(VariableDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        
        let varName = try varName(from: varDec).description
        let privateKeyVarName = "\(privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let (keyArg, codingArg, encodeArg, decodeArg) = try args(from: node)
        // use variable name as the key name if key was not supplied
        let keyName = keyArg?.expression.description ?? "\"\(varName)\""
        
        var customCodingDecl: String? = nil
        if hasCustomCoding {
            guard let codingArg else {
                throw PrefMacroError.missingCodingArgument
            }
            customCodingDecl = codingArg.expression.description
        } else if hasInlineCoding {
            guard let encodeArg, let decodeArg else {
                throw PrefMacroError.missingCodingArgument
            }
            customCodingDecl = "PrefCoding(encode: \(encodeArg.expression.description), decode: \(decodeArg.expression.description))"
        }
        
        let typeInfo = try TypeBindingInfo(
            for: Self.self,
            from: varDec,
            keyName: keyName,
            privateKeyVarName: privateKeyVarName,
            privateValueVarName: privateValueVarName,
            customCodingDecl: customCodingDecl
        )
        
        return [
            """
            \(raw: typeInfo.privateKeyVarDeclaration)
            """,
            """
            \(raw: typeInfo.privateValueVarDeclaration)
            """
        ]
    }
}

// MARK: - Helpers

extension PrefMacro {
    static var moduleNamePrefix: String { "PrefsKitTypes." }
    
    static var privateCodingVarPrefix: String { "__PrefCoding_" }
    static var privateValueVarPrefix: String { "__PrefValue_" }
}

extension PrefMacro {
    static func args(from node: AttributeSyntax) throws(PrefMacroError) -> (
        key: LabeledExprSyntax?,
        coding: LabeledExprSyntax?,
        encode: LabeledExprSyntax?,
        decode: LabeledExprSyntax?
    ) {
        guard node.arguments != nil else {
            // no `key:`, or subsequent `coding:` / `encode:`/`decode:`
            // we'll derive key name from variable name upon return.
            return (key: nil, coding: nil, encode: nil, decode: nil)
        }
        
        guard let args = node.arguments?.as(LabeledExprListSyntax.self)
        else {
            throw .incorrectSyntax
        }
        
        var remainingArgs = args
        
        func nextArg() throws(PrefMacroError) -> (LabeledExprSyntax, label: String)? {
            guard !remainingArgs.isEmpty else { return nil }
            let idx = remainingArgs.startIndex
            let arg = remainingArgs[idx]
            remainingArgs.remove(at: idx)
            
            guard let label = arg.label?.trimmedDescription else { throw .invalidArgumentLabel }
            return (arg, label)
        }
        
        var key: LabeledExprSyntax?
        var coding: LabeledExprSyntax?
        var encode: LabeledExprSyntax?
        var decode: LabeledExprSyntax?
        
        var tuple: (
            key: LabeledExprSyntax?,
            coding: LabeledExprSyntax?,
            encode: LabeledExprSyntax?,
            decode: LabeledExprSyntax?
        ) { (key, coding, encode, decode) }
        
        var currentArg: LabeledExprSyntax
        var currentArgLabel: String
        
        // arg could be `key:`, or `coding:`, or `encode:`
        guard let (a, l) = try nextArg() else {
            // no `key:`, or subsequent `coding:` / `encode:`/`decode:`
            // we'll derive key name from variable name upon return.
            return tuple
        }
        currentArg = a; currentArgLabel = l
        
        if currentArgLabel == "key" {
            key = currentArg
            
            // we can accept a `nil` literal as equivalent to the argument not being found (if it was defaulted to `nil`)
            if currentArg.expression.description == "nil" { key = nil }
            
            guard let (a, l) = try nextArg() else {
                // no subsequent `coding:` / `encode:`/`decode:`
                return tuple
            }
            currentArg = a; currentArgLabel = l
            currentArg = a; currentArgLabel = l
        }
        
        switch currentArgLabel {
        case "coding":
            coding = currentArg
            
            guard (try? nextArg()) == nil else {
                throw .tooManyArguments
            }
            
            return tuple
        case "encode":
            encode = currentArg
            
            guard let (a, l) = try nextArg() else {
                throw .missingCodingArgument
            }
            currentArg = a; currentArgLabel = l
            
            if currentArgLabel == "decode" {
                decode = currentArg
                
                guard (try? nextArg()) == nil else {
                    throw .tooManyArguments
                }
                
                return tuple
            } else {
                throw .incorrectSyntax
            }
        default:
            throw .incorrectSyntax
        }
    }
    
    static func varName(from declaration: VariableDeclSyntax) throws(PrefMacroError) -> IdentifierPatternSyntax {
        guard let val = declaration.bindings.first?.pattern
            .as(IdentifierPatternSyntax.self)
        else {
            throw .invalidVariableName
        }
        return val
    }
}

extension PrefMacro {
    static func typeBinding(from declaration: VariableDeclSyntax) throws(PrefMacroError) -> TypeBinding {
        guard let val = declaration.bindings.first?.typeAnnotation?.type
        else {
            throw .missingOrInvalidTypeAnnotation
        }
        
        if let optionalTypeBinding = val.as(OptionalTypeSyntax.self) {
            return .optional(optionalTypeBinding.wrappedType)
        } else {
            return .nonOptional(val)
        }
    }
}

extension PrefMacro {
    static func defaultValue(from declaration: VariableDeclSyntax) throws(PrefMacroError) -> ExprSyntax {
        guard let val = declaration.bindings.first?.initializer?.value
        else {
            throw .missingDefaultValue
        }
        return val
    }
}
