//
//  Macro Declarations.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
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
public macro Pref<Coding: PrefsCodable>(key: String? = nil, coding: Coding)
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

// MARK: - JSONDataCodablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro JSONDataCodablePref(key: String? = nil)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "JSONDataCodablePrefMacro")

// MARK: - JSONStringCodablePref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefCoding_), prefixed(__PrefValue_))
public macro JSONStringCodablePref(key: String? = nil)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "JSONStringCodablePrefMacro")

// MARK: - RawPref

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /* arbitrary */ prefixed(__PrefValue_))
public macro RawPref(key: String? = nil)
    = #externalMacro(module: "PrefsKitMacrosImplementation", type: "RawPrefMacro")
