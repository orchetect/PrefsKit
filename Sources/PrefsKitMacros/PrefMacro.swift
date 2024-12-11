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

public struct PrefMacro { }

extension PrefMacro {
    static let moduleNamePrefix = "PrefsKitCore."
    
    static let privateKeyVarPrefix = "__PrefKey_"
    static let privateValueVarPrefix = "__PrefValue_"
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
    enum TypeBinding {
        case nonOptional(TypeSyntax)
        case optional(TypeSyntax)
        
        var isOptional: Bool {
            switch self {
            case .nonOptional: false
            case .optional: true
            }
        }
        
        var description: String {
            switch self {
            case let .nonOptional(typeSyntax):
                typeSyntax.trimmedDescription
            case let .optional(typeSyntax):
                typeSyntax.trimmedDescription
            }
        }
    }
    
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
    
    struct TypeBindingInfo {
        let isOptional: Bool
        let typeName: String
        let keyStructName: String
        let keyDeclaration: String
        let getValueSyntax: String
        let privateVarDeclaration: String
        
        init(from declaration: some DeclSyntaxProtocol, keyName: String) throws {
            guard let varDec = declaration.as(VariableDeclSyntax.self)
            else {
                throw PrefMacroError.incorrectSyntax
            }
            try self.init(from: varDec, keyName: keyName)
        }
        
        init(from varDec: VariableDeclSyntax, keyName: String) throws {
            let typeBinding = try typeBinding(from: varDec)
            typeName = typeBinding.description
            
            isOptional = typeBinding.isOptional
            if isOptional {
                // must not have a default value
                guard (try? defaultValue(from: varDec)) == nil else {
                    throw PrefMacroError.noDefaultValueAllowed
                }
                keyStructName = "\(moduleNamePrefix)AnyAtomicPrefKey<\(typeName)>"
                keyDeclaration = keyStructName + "(key: \(keyName))"
                getValueSyntax = "getValue(in: storage)"
                privateVarDeclaration = "\(typeName)?"
            } else {
                // must have a default value
                let defaultValue = try defaultValue(from: varDec)
                keyStructName = "\(moduleNamePrefix)AnyDefaultedAtomicPrefKey<\(typeName)>"
                keyDeclaration = keyStructName + "(key: \(keyName), defaultValue: \(defaultValue))"
                getValueSyntax = "getDefaultedValue(in: storage)"
                privateVarDeclaration = "\(typeName) = \(defaultValue)"
            }
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

extension PrefMacro: AccessorMacro {
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
        
        let keyName = try keyArg(from: node).expression.description
        let varName = try varName(from: varDec)
        let privateKeyVarName = "\(privateKeyVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let typeInfo = try TypeBindingInfo(from: varDec, keyName: keyName)
        
        let keyPath = "\\.\(varName)"
        
        return [
            """
            get {
                _$observationRegistrar.access(self, keyPath: \(raw: keyPath))
                \(raw: privateValueVarName) = \(raw: privateKeyVarName).\(raw: typeInfo.getValueSyntax)
                return \(raw: privateValueVarName)
            }
            """,
            """
            set {
                withMutation(keyPath: \(raw: keyPath)) {
                    \(raw: privateKeyVarName).setValue(to: newValue, in: storage)
                    \(raw: privateValueVarName) = newValue
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
                yield &\(raw: privateValueVarName)
                \(raw: privateKeyVarName).setValue(to: \(raw: privateValueVarName), in: storage)
            }
            """
        ]
    }
}

extension PrefMacro: PeerMacro {
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
        let privateKeyVarName = "\(privateKeyVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let typeInfo = try TypeBindingInfo(from: varDec, keyName: keyName)
        
        return [
            """
            private let \(raw: privateKeyVarName) = \(raw: typeInfo.keyDeclaration)
            """,
            """
            private var \(raw: privateValueVarName): \(raw: typeInfo.privateVarDeclaration)
            """
        ]
    }
}

extension PrefMacro {
    public enum PrefMacroError: LocalizedError {
        case missingKeyArgument
        case incorrectSyntax
        case invalidKeyArgumentType
        case invalidVariableName
        case notVarDeclaration
        case missingDefaultValue
        case missingOrInvalidTypeAnnotation
        case modifiersNotAllowed
        case noDefaultValueAllowed
        
        public var errorDescription: String? {
            switch self {
            case .missingKeyArgument:
                "Missing value for key argument."
            case .incorrectSyntax:
                "Incorrect syntax."
            case .invalidKeyArgumentType:
                "Invalid key argument type."
            case .invalidVariableName:
                "Invalid variable name."
            case .notVarDeclaration:
                "Must be a var declaration."
            case .missingDefaultValue:
                "Missing default value."
            case .missingOrInvalidTypeAnnotation:
                "Missing or invalid type annotation."
            case .modifiersNotAllowed:
                "Modifiers are not allowed."
            case .noDefaultValueAllowed:
                "No default value allowed."
            }
        }
    }
}
