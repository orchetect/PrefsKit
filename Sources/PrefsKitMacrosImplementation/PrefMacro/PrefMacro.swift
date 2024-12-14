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
        
        guard varDec.modifiers.isEmpty else {
            throw PrefMacroError.modifiersNotAllowed
        }
        
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
        
        let (keyArg, codingArg) = try args(from: node)
        // use variable name as the key name if key was not supplied
        let keyName = keyArg?.expression.description ?? "\"\(varName)\""
        
        var customCodingDecl: String? = nil
        if hasCustomCoding {
            guard let codingArg else {
                throw PrefMacroError.missingCodingArgument
            }
            customCodingDecl = codingArg.expression.description
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
    static func args(from node: AttributeSyntax) throws -> (key: LabeledExprSyntax?, coding: LabeledExprSyntax?) {
        guard node.arguments != nil else {
            // no `key:` or `coding:` arg. we'll derive key name from variable name upon return.
            return (key: nil, coding: nil)
        }
        
        guard let args = node.arguments?.as(LabeledExprListSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        guard !args.isEmpty else {
            // no `key:` or `coding:` arg. we'll derive key name from variable name upon return.
            return (key: nil, coding: nil)
        }
        
        // arg could be `key:` or could be `coding:`
        let arg1 = args[args.startIndex]
        
        guard let arg1Label = arg1.label?.trimmedDescription else {
            throw PrefMacroError.incorrectSyntax
        }
        
        func parseKey(from arg: LabeledExprSyntax) throws -> LabeledExprSyntax? {
            var key: LabeledExprSyntax? = arg
            
            guard let label = key?.label?.trimmedDescription,
                  label == "key"
            else {
                throw PrefMacroError.incorrectSyntax
            }
            
            // probably skip this check since we don't require key name to be a string literal,
            // and it's difficult/impossible to know whether an expression evaluates to
            // a String output value. we'll just take the syntax as-is and leave that up to the compiler.
            // guard arg.expression.syntaxNodeType == StringLiteralExprSyntax.self
            // else {
            //     throw PrefMacroError.invalidKeyArgumentType
            // }
            
            // we can accept a `nil` literal as equivalent to the argument not being found (if it was defaulted to `nil`)
            if key?.expression.description == "nil" { key = nil }
            
            return key
        }
        
        func parseCoding(from arg: LabeledExprSyntax) throws -> LabeledExprSyntax? {
            let coding: LabeledExprSyntax? = arg
            
            guard let label = coding?.label?.trimmedDescription,
                  label == "coding"
            else {
                throw PrefMacroError.incorrectSyntax
            }
            
            return coding
        }
        
        switch arg1Label {
        case "key":
            let key = try parseKey(from: arg1)
            
            let coding: LabeledExprSyntax? = args.count > 1
                ? try parseCoding(from: args[args.index(args.startIndex, offsetBy: 1)])
                : nil
            
            return (key: key, coding: coding)
        case "coding":
            // user omitted/defaulted the `key` argument but supplied a `coding` argument.
            // we'll derive key name from variable name upon return.
            
            let coding = try parseCoding(from: arg1)
            
            return (key: nil, coding: coding)
        default:
            throw PrefMacroError.invalidArgumentLabel
        }
    }
    
    static func varName(from declaration: VariableDeclSyntax) throws -> IdentifierPatternSyntax {
        guard let val = declaration.bindings.first?.pattern
            .as(IdentifierPatternSyntax.self)
        else {
            throw PrefMacroError.invalidVariableName
        }
        return val
    }
}

extension PrefMacro {
    static func typeBinding(from declaration: VariableDeclSyntax) throws -> TypeBinding {
        guard let val = declaration.bindings.first?.typeAnnotation?.type
        else {
            throw PrefMacroError.missingOrInvalidTypeAnnotation
        }
        
        if let optionalTypeBinding = val.as(OptionalTypeSyntax.self) {
            return .optional(optionalTypeBinding.wrappedType)
        } else {
            return .nonOptional(val)
        }
    }
}

extension PrefMacro {
    static func defaultValue(from declaration: VariableDeclSyntax) throws -> ExprSyntax {
        guard let val = declaration.bindings.first?.initializer?.value
        else {
            throw PrefMacroError.missingDefaultValue
        }
        return val
    }
}
