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
        let keyArg = try keyArg(from: node)
        let keyName = keyArg.expression.description
        
        guard let varDec = declaration.as(VariableDeclSyntax.self)
        else {
            throw PrefMacroError.incorrectSyntax
        }
        
        let varName = try varName(from: varDec).description
        let privateKeyVarName = "\(privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let typeInfo = try TypeBindingInfo(
            for: Self.self,
            from: varDec,
            keyName: keyName,
            privateKeyVarName: privateKeyVarName,
            privateValueVarName: privateValueVarName
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
    static var moduleNamePrefix: String { "PrefsKitCore." }
    
    static var privateCodingVarPrefix: String { "__PrefCoding_" }
    static var privateValueVarPrefix: String { "__PrefValue_" }
}

extension PrefMacro {
    static func keyArg(from node: AttributeSyntax) throws -> LabeledExprSyntax {
        guard let keyArg = node.arguments?
            .as(LabeledExprListSyntax.self)?
            .first
        else {
            throw PrefMacroError.missingKeyArgument
        }
        
        // probably skip this check since we don't require key name to be a string literal,
        // and it's difficult/impossible to know whether an expression evaluates to
        // a String output value. we'll just take the syntax as-is and leave that up to the compiler.
        // guard keyArg.expression.syntaxNodeType == StringLiteralExprSyntax.self
        // else {
        //     throw PrefMacroError.invalidKeyArgumentType
        // }
        
        return keyArg
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
