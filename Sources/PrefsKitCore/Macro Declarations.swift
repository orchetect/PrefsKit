//
//  Macro Declarations.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitTypes

// MARK: - Prefs (Class)

@attached(member, names: named(_$observationRegistrar))
@attached(extension, names: named(access), named(withMutation), conformances: Observable & PrefsSchema)
public macro PrefsSchema() = #externalMacro(module: "PrefsKitMacrosImplementation", type: "PrefsSchemaMacro")

// MARK: - *Pref (Variable-Attached)

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref(key: String) = #externalMacro(module: "PrefsKitMacrosImplementation", type: "AtomicPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref(key: String, coding: any PrefsCodable) = #externalMacro(module: "PrefsKitMacrosImplementation", type: "CustomPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro RawRepresentablePref(key: String) = #externalMacro(module: "PrefsKitMacrosImplementation", type: "RawRepresentablePrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro JSONCodablePref(key: String) = #externalMacro(module: "PrefsKitMacrosImplementation", type: "JSONCodablePrefMacro")
