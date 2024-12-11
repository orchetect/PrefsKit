//
//  PrefsMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PrefsMacro { }

extension PrefsMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            """
            @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()
            """
        ]
    }
}

extension PrefsMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let equatableExtension = try ExtensionDeclSyntax(
            """
            extension \(type.trimmed): Observable {
                internal nonisolated func access<Member>(
                    keyPath: KeyPath<\(type.trimmed), Member>
                ) {
                    _$observationRegistrar.access(self, keyPath: keyPath)
                }
                
                internal nonisolated func withMutation<Member, MutationResult>(
                    keyPath: KeyPath<\(type.trimmed), Member>,
                    _ mutation: () throws -> MutationResult
                ) rethrows -> MutationResult {
                    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
                }
            }
            """
        )
        return [equatableExtension]
    }
}

extension PrefsMacro {
    public enum PrefsMacroError: LocalizedError {
        case incorrectSyntax
        
        public var errorDescription: String? {
            switch self {
            case .incorrectSyntax:
                "Incorrect syntax."
            }
        }
    }
}
