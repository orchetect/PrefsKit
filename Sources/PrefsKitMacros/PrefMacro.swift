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
    
    static let privateCodingVarPrefix = "__PrefCoding_"
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
        let keyAndCodingStructName: String
        let keyAndCodingStructDeclaration: String
        let privateKeyVarDeclaration: String
        let privateValueVarDeclaration: String
        
        init(
            from declaration: some DeclSyntaxProtocol,
            keyName: String,
            privateKeyVarName: String,
            privateValueVarName: String
        ) throws {
            guard let varDec = declaration.as(VariableDeclSyntax.self)
            else {
                throw PrefMacroError.incorrectSyntax
            }
            try self.init(
                from: varDec,
                keyName: keyName,
                privateKeyVarName: privateKeyVarName,
                privateValueVarName: privateValueVarName
            )
        }
        
        init(
            from varDec: VariableDeclSyntax,
            keyName: String,
            privateKeyVarName: String,
            privateValueVarName: String
        ) throws {
            let typeBinding = try typeBinding(from: varDec)
            typeName = typeBinding.description
            
            isOptional = typeBinding.isOptional
            if isOptional {
                // must not have a default value
                guard (try? defaultValue(from: varDec)) == nil else {
                    throw PrefMacroError.noDefaultValueAllowed
                }
                keyAndCodingStructName = "\(moduleNamePrefix)AnyAtomicPrefsKey<\(typeName)>"
                keyAndCodingStructDeclaration = keyAndCodingStructName + "(key: \(keyName))"
                privateKeyVarDeclaration = "private let \(privateKeyVarName) = \(keyAndCodingStructDeclaration)"
                privateValueVarDeclaration = "private var \(privateValueVarName): \(typeName)?"
            } else {
                // must have a default value
                let defaultValue = try defaultValue(from: varDec)
                keyAndCodingStructName = "\(moduleNamePrefix)AnyDefaultedAtomicPrefsKey<\(typeName)>"
                keyAndCodingStructDeclaration = keyAndCodingStructName + "(key: \(keyName), defaultValue: \(defaultValue))"
                privateKeyVarDeclaration = "private let \(privateKeyVarName) = \(keyAndCodingStructDeclaration)"
                privateValueVarDeclaration = "private var \(privateValueVarName): \(typeName)?"
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
        
        let varName = try varName(from: varDec)
        let privateKeyVarName = "\(privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let keyPath = #"\."# + varName.description
        
        let hasDefault = (try? self.defaultValue(from: varDec)) != nil
        
        return [
            """
            get {
                _$observationRegistrar.access(self, keyPath: \(raw: keyPath))
                if isCacheEnabled {
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = storage.value(forKey: \(raw: privateKeyVarName))
                    }
                    return \(raw: privateValueVarName)\(raw: hasDefault ? " ?? \(privateKeyVarName).defaultValue" : "")
                } else {
                    return storage.value(forKey: \(raw: privateKeyVarName))
                }
            }
            """,
            """
            set {
                withMutation(keyPath: \(raw: keyPath)) {
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: newValue)
                    if isCacheEnabled {
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
                if isCacheEnabled {
                    if \(raw: privateValueVarName) == nil {
                        \(raw: privateValueVarName) = storage.value(forKey: \(raw: privateKeyVarName))
                    }
                    yield &\(raw: privateValueVarName)\(raw: hasDefault ? "!" : "")
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: \(raw: privateValueVarName))
                } else {
                    var val = storage.value(forKey: \(raw: privateKeyVarName))
                    yield &val
                    storage.setValue(forKey: \(raw: privateKeyVarName), to: val)
                }
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
        let privateKeyVarName = "\(privateCodingVarPrefix)\(varName)"
        let privateValueVarName = "\(privateValueVarPrefix)\(varName)"
        
        let typeInfo = try TypeBindingInfo(
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
