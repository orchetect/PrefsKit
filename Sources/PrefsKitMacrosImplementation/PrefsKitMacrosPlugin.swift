//
//  PrefsKitMacrosPlugin.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftCompilerPlugin)

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PrefsKitMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PrefsSchemaMacro.self,
        AtomicPrefMacro.self,
        CodingPrefMacro.self,
        InlinePrefMacro.self,
        RawRepresentablePrefMacro.self,
        JSONDataCodablePrefMacro.self,
        JSONStringCodablePrefMacro.self,
        RawPrefMacro.self
    ]
}

#endif
