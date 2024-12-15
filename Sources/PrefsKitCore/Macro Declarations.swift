//
//  Macro Declarations.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitTypes

// MARK: - PrefsSchema (Class)

@attached(member, names: named(_$observationRegistrar))
@attached(extension, names: named(access), named(withMutation), conformances: Observable & PrefsSchema)
public macro PrefsSchema()
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "PrefsSchemaMacro")

// MARK: - Pref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref(key: String? = nil)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "AtomicPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref(key: String? = nil, coding: any PrefsCodable)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "CodingPrefMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro Pref<Value, StorageValue>(
    key: String? = nil,
    encode: (Value) -> StorageValue?,
    decode: (StorageValue) -> Value?
)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "InlinePrefMacro")

// MARK: - RawRepresentablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro RawRepresentablePref(key: String? = nil)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "RawRepresentablePrefMacro")

// MARK: - JSONCodablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro JSONCodablePref(key: String? = nil)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "JSONCodablePrefMacro")
