//
//  PrefsSchemaMacroError.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsSchemaMacro {
    public enum PrefsSchemaMacroError: LocalizedError {
        case incorrectSyntax
        
        public var errorDescription: String? {
            switch self {
            case .incorrectSyntax:
                "Incorrect syntax."
            }
        }
    }
}

extension PrefsSchemaMacro.PrefsSchemaMacroError: CustomStringConvertible {
    public var description: String { errorDescription ?? localizedDescription }
}
