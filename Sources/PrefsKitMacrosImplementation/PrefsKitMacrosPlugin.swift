//
//  PrefsKitMacrosPlugin.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PrefsKitMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PrefsMacro.self,
        AtomicPrefMacro.self,
        CustomPrefMacro.self,
        RawRepresentablePrefMacro.self,
        JSONCodablePrefMacro.self
    ]
}
