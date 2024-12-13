//
//  PrefsKey Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

// MARK: - Atomic

/// Generic concrete pref key with an atomic value type.
public struct AnyAtomicPrefsKey<Value>: PrefsKey
    where Value: Sendable, Value: PrefsStorageValue
{
    public typealias StorageValue = Value
    
    public let key: String
    public let coding = AtomicPrefsCoding<Value>()
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with an atomic value type and a default value.
public struct AnyDefaultedAtomicPrefsKey<Value>: DefaultedPrefsKey
    where Value: Sendable, Value: PrefsStorageValue
{
    public typealias StorageValue = Value
    
    public let key: String
    public let defaultValue: Value
    public let coding = AtomicPrefsCoding<Value>()
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - Base

/// Generic concrete pref key with a different value type from its raw storage type.
public struct AnyPrefsKey<Value, StorageValue>: PrefsKey
    where Value: RawRepresentable, Value.RawValue == StorageValue, Value: Sendable,
    StorageValue: PrefsStorageValue
{
    public let key: String
    public let coding: PrefsCoding<Value, StorageValue>
    
    public init(key: String, coding: PrefsCoding<Value, StorageValue>) {
        self.key = key
        self.coding = coding
    }
    
    public init(
        key: String,
        encode: @escaping @Sendable (Value) -> StorageValue?,
        decode: @escaping @Sendable (StorageValue) -> Value?
    ) {
        self.key = key
        coding = .init(encode: encode, decode: decode)
    }
}

/// Generic concrete pref key with a different value type from its raw storage type and a default value.
public struct AnyDefaultedPrefsKey<Value, StorageValue>: DefaultedPrefsKey
    where Value: RawRepresentable, Value.RawValue == StorageValue, Value: Sendable,
    StorageValue: PrefsStorageValue
{
    public let key: String
    public let defaultValue: Value
    public let coding: PrefsCoding<Value, StorageValue>
    
    public init(
        key: String,
        defaultValue: Value,
        coding: PrefsCoding<Value, StorageValue>
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.coding = coding
    }
    
    public init(
        key: String,
        defaultValue: Value,
        encode: @escaping @Sendable (Value) -> StorageValue?,
        decode: @escaping @Sendable (StorageValue) -> Value?
    ) {
        self.key = key
        self.defaultValue = defaultValue
        coding = .init(encode: encode, decode: decode)
    }
}

// MARK: - RawRepresentable

/// Generic concrete pref key with a `RawRepresentable` value type.
public struct AnyRawRepresentablePrefsKey<Value, StorageValue>: PrefsKey
    where Value: RawRepresentable, Value.RawValue == StorageValue, Value: Sendable,
    StorageValue: PrefsStorageValue
{
    public let key: String
    public let coding = RawRepresentablePrefsCoding<Value>()
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `RawRepresentable` value type and a default value.
public struct AnyDefaultedRawRepresentablePrefsKey<Value, StorageValue>: DefaultedPrefsKey
    where Value: RawRepresentable, Value: Sendable, StorageValue: PrefsStorageValue,
    Value.RawValue == StorageValue
{
    public let key: String
    public let defaultValue: Value
    public let coding = RawRepresentablePrefsCoding<Value>()
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - Codable

/// Generic concrete pref key with a `Codable` value type.
public struct AnyCodablePrefsKey<Value, StorageValue, Encoder, Decoder>: PrefsKey
    where Value: Codable, Value: Sendable,
    StorageValue: PrefsStorageValue, StorageValue == Encoder.Output,
    Encoder: TopLevelEncoder, Encoder: Sendable, Encoder.Output: PrefsStorageValue,
    Decoder: TopLevelDecoder, Decoder: Sendable, Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public let key: String
    public let coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>
    
    public init(key: String, coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>) {
        self.key = key
        self.coding = coding
    }
    
    public init(
        key: String,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.key = key
        coding = .init(encoder: encoder(), decoder: decoder())
    }
}

/// Generic concrete pref key with a `Codable` value type and a default value.
public struct AnyDefaultedCodablePrefsKey<Value, StorageValue, Encoder, Decoder>: DefaultedPrefsKey
    where Value: Codable, Value: Sendable,
    StorageValue: PrefsStorageValue, StorageValue == Encoder.Output,
    Encoder: TopLevelEncoder, Encoder: Sendable, Encoder.Output: PrefsStorageValue,
    Decoder: TopLevelDecoder, Decoder: Sendable, Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public let key: String
    public let defaultValue: Value
    public let coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>
    
    public init(
        key: String,
        defaultValue: Value,
        coding: CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.coding = coding
    }
    
    public init(
        key: String,
        defaultValue: Value,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.key = key
        self.defaultValue = defaultValue
        coding = .init(encoder: encoder(), decoder: decoder())
    }
}

// MARK: - JSON Codable

/// Generic concrete pref key with a `Codable` value type using JSON encoding.
public struct AnyJSONCodablePrefsKey<Value>: PrefsKey
    where Value: Codable, Value: Sendable
{
    public let key: String
    public let coding = JSONCodablePrefsCoding<Value>()
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `Codable` value type using JSON encoding and a default value.
public struct AnyDefaultedJSONCodablePrefsKey<Value>: DefaultedPrefsKey
    where Value: Codable, Value: Sendable
{
    public let key: String
    public let defaultValue: Value
    public let coding = JSONCodablePrefsCoding<Value>()
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
