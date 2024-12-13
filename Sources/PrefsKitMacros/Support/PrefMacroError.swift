//
//  PrefMacroError.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
