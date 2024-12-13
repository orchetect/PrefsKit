//
//  Macro Declarations.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Prefs (Class)

@attached(member, names: named(_$observationRegistrar))
@attached(extension, names: named(access), named(withMutation), conformances: Observable)
public macro Prefs() = #externalMacro(module: "PrefsKitMacros", type: "PrefsMacro")

// MARK: - *Pref (Variable-Attached)

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref(key: String) = #externalMacro(module: "PrefsKitMacros", type: "AtomicPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro RawRepresentablePref(key: String) = #externalMacro(module: "PrefsKitMacros", type: "RawRepresentablePrefMacro")
