//
//  PrefsKey Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

// MARK: - Atomic

/// Generic concrete pref key with an atomic value type.
public struct AnyAtomicPrefsKey<Value>: AtomicPrefsCodable where Value: Sendable, Value: PrefsStorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = Value
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with an atomic value type and a default value.
public struct AnyDefaultedAtomicPrefsKey<Value>: AtomicPrefsCodable where Value: Sendable, Value: PrefsStorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = Value
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - RawRepresentable

/// Generic concrete pref key with a `RawRepresentable` value type.
public struct AnyRawRepresentablePrefsKey<
    Value: RawRepresentable,
    StorageValue: PrefsStorageValue
>: RawRepresentablePrefsCodable where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `RawRepresentable` value type and a default value.
public struct AnyDefaultedRawRepresentablePrefsKey<
    Value: RawRepresentable,
    StorageValue: PrefsStorageValue
>: RawRepresentablePrefsCodable where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

// MARK: - Codable

/// Generic concrete pref key with a `Codable` value type.
public struct AnyCodablePrefsKey<
    Value: Codable,
    StorageValue: PrefsStorageValue,
    Encoder: TopLevelEncoder,
    Decoder: TopLevelDecoder
>: CodablePrefsCodable where Value: Sendable,
    StorageValue == Encoder.Output,
    Encoder.Output: PrefsStorageValue,
    Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    
    public typealias Encoder = Encoder
    public typealias Decoder = Decoder
    private let _encoder: @Sendable () -> Encoder
    private let _decoder: @Sendable () -> Decoder
    
    public init(
        key: String,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.key = key
        _encoder = encoder
        _decoder = decoder
    }
    
    public func prefsEncoder() -> Encoder { _encoder() }
    public func prefsDecoder() -> Decoder { _decoder() }
}

/// Generic concrete pref key with a `Codable` value type and a default value.
public struct AnyDefaultedCodablePrefsKey<
    Value: Codable,
    StorageValue: PrefsStorageValue,
    Encoder: TopLevelEncoder,
    Decoder: TopLevelDecoder
>: CodablePrefsCodable where Value: Sendable,
    StorageValue == Encoder.Output,
    Encoder.Output: PrefsStorageValue,
    Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    public let defaultValue: Value
    
    public typealias Encoder = Encoder
    public typealias Decoder = Decoder
    private let _encoder: @Sendable () -> Encoder
    private let _decoder: @Sendable () -> Decoder
    
    public init(
        key: String,
        defaultValue: Value,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.key = key
        self.defaultValue = defaultValue
        _encoder = encoder
        _decoder = decoder
    }
    
    public func prefsEncoder() -> Encoder { _encoder() }
    public func prefsDecoder() -> Decoder { _decoder() }
}

// MARK: - JSON Codable

/// Generic concrete pref key with a `Codable` value type using JSON encoding.
public struct AnyJSONCodablePrefsKey<Value: Codable>: JSONCodablePrefsCodable where Value: Sendable {
    public let key: String
    
    public typealias Value = Value
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `Codable` value type using JSON encoding and a default value.
public struct AnyDefaultedJSONCodablePrefsKey<Value: Codable>: JSONCodablePrefsCodable where Value: Sendable {
    public let key: String
    
    public typealias Value = Value
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
