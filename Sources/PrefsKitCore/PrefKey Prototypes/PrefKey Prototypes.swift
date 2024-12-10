//
//  PrefKey Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

// MARK: - Atomic

/// Generic concrete pref key with an atomic value type.
public struct AnyAtomicPrefKey<Value>: AtomicPrefKey where Value: Sendable, Value: PrefStorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = Value
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with an atomic value type and a default value.
public struct AnyDefaultedAtomicPrefKey<Value>: AtomicDefaultedPrefKey where Value: Sendable, Value: PrefStorageValue {
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
public struct AnyRawRepresentablePrefKey<
    Value: RawRepresentable,
    StorageValue: PrefStorageValue
>: RawRepresentablePrefKey where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `RawRepresentable` value type and a default value.
public struct AnyDefaultedRawRepresentablePrefKey<
    Value: RawRepresentable,
    StorageValue: PrefStorageValue
>: DefaultedRawRepresentablePrefKey where Value: Sendable, Value.RawValue == StorageValue {
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
public struct AnyCodablePrefKey<
    Value: Codable,
    StorageValue: PrefStorageValue,
    Encoder: TopLevelEncoder,
    Decoder: TopLevelDecoder
>: CodablePrefKey where Value: Sendable,
                        StorageValue == Encoder.Output,
                        Encoder.Output: PrefStorageValue,
                        Decoder.Input: PrefStorageValue,
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
        self._encoder = encoder
        self._decoder = decoder
    }
    
    public func prefEncoder() -> Encoder { _encoder() }
    public func prefDecoder() -> Decoder { _decoder() }
}

/// Generic concrete pref key with a `Codable` value type and a default value.
public struct AnyDefaultedCodablePrefKey<
    Value: Codable,
    StorageValue: PrefStorageValue,
    Encoder: TopLevelEncoder,
    Decoder: TopLevelDecoder
>: DefaultedCodablePrefKey where Value: Sendable,
                                 StorageValue == Encoder.Output,
                                 Encoder.Output: PrefStorageValue,
                                 Decoder.Input: PrefStorageValue,
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
        self._encoder = encoder
        self._decoder = decoder
    }
    
    public func prefEncoder() -> Encoder { _encoder() }
    public func prefDecoder() -> Decoder { _decoder() }
}

// MARK: - JSON Codable

/// Generic concrete pref key with a `Codable` value type using JSON encoding.
public struct AnyJSONCodablePrefKey<Value: Codable>: JSONCodablePrefKey where Value: Sendable {
    public let key: String
    
    public typealias Value = Value
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `Codable` value type using JSON encoding and a default value.
public struct AnyDefaultedJSONCodablePrefKey<Value: Codable>: DefaultedJSONCodablePrefKey where Value: Sendable {
    public let key: String
    
    public typealias Value = Value
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
