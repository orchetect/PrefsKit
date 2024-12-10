//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// Protocol for prefs schema.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol PrefsSchema where Self: Sendable {
    var storage: any PrefsStorage { get }
    var isCacheEnabled: Bool { get }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    public func pref<Key: PrefKey>(_ key: Key) -> ObservablePref<Key> {
        ObservablePref(key: key, storage: storage, isCacheEnabled: isCacheEnabled)
    }
    
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    public func pref<Key: DefaultedPrefKey>(_ key: Key) -> ObservableDefaultedPref<Key> {
        ObservableDefaultedPref(key: key, storage: storage, isCacheEnabled: isCacheEnabled)
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    // MARK: - Atomic
    
    /// Synthesize a pref key with an `Int` value.
    public func pref(
        int key: String
    ) -> ObservablePref<AnyAtomicPrefKey<Int>> {
        let keyInstance = AnyAtomicPrefKey<Int>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `String` value.
    public func pref(
        string key: String
    ) -> ObservablePref<AnyAtomicPrefKey<String>> {
        let keyInstance = AnyAtomicPrefKey<String>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value.
    public func pref(
        bool key: String
    ) -> ObservablePref<AnyAtomicPrefKey<Bool>> {
        let keyInstance = AnyAtomicPrefKey<Bool>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value.
    public func pref(
        double key: String
    ) -> ObservablePref<AnyAtomicPrefKey<Double>> {
        let keyInstance = AnyAtomicPrefKey<Double>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value.
    public func pref(
        float key: String
    ) -> ObservablePref<AnyAtomicPrefKey<Float>> {
        let keyInstance = AnyAtomicPrefKey<Float>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value.
    public func pref(
        data key: String
    ) -> ObservablePref<AnyAtomicPrefKey<Data>> {
        let keyInstance = AnyAtomicPrefKey<Data>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref(
        array key: String
    ) -> ObservablePref<AnyAtomicPrefKey<AnyPrefArray>> {
        let keyInstance = AnyAtomicPrefKey<AnyPrefArray>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref<Element: PrefStorageValue>(
        array key: String,
        of elementType: Element.Type
    ) -> ObservablePref<AnyAtomicPrefKey<[Element]>> {
        let keyInstance = AnyAtomicPrefKey<[Element]>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref<Element: PrefStorageValue>(
        dictionary key: String,
        of elementType: Element.Type
    ) -> ObservablePref<AnyAtomicPrefKey<[String: Element]>> {
        let keyInstance = AnyAtomicPrefKey<[String: Element]>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref(
        dictionary key: String
    ) -> ObservablePref<AnyAtomicPrefKey<AnyPrefDictionary>> {
        let keyInstance = AnyAtomicPrefKey<AnyPrefDictionary>(key: key)
        return pref(keyInstance)
    }
    
    // MARK: - Atomic Defaulted
    
    /// Synthesize a pref key with an `Int` value with a default value.
    public func pref(
        int key: String,
        default defaultValue: Int
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<Int>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<Int>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `String` value with a default value.
    public func pref(
        string key: String,
        default defaultValue: String
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<String>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<String>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value with a default value.
    public func pref(
        bool key: String,
        default defaultValue: Bool
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<Bool>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<Bool>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value with a default value.
    public func pref(
        double key: String,
        default defaultValue: Double
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<Double>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<Double>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value with a default value.
    public func pref(
        float key: String,
        default defaultValue: Float
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<Float>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<Float>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value with a default value.
    public func pref(
        data key: String,
        default defaultValue: Data
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<Data>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<Data>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref(
        array key: String,
        default defaultValue: AnyPrefArray
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<AnyPrefArray>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<AnyPrefArray>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref<Element: PrefStorageValue>(
        array key: String,
        of elementType: Element.Type,
        default defaultValue: [Element]
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<[Element]>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<[Element]>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref(
        dictionary key: String,
        default defaultValue: AnyPrefDictionary
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<AnyPrefDictionary>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<AnyPrefDictionary>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref<Element: PrefStorageValue>(
        dictionary key: String,
        of elementType: Element.Type,
        default defaultValue: [String: Element]
    ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefKey<[String: Element]>> {
        let keyInstance = AnyDefaultedAtomicPrefKey<[String: Element]>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    // MARK: - RawRepresentable
    
    /// Synthesize a pref key with an `RawRepresentable` value.
    public func pref<Value: RawRepresentable, StorageValue: PrefStorageValue>(
        _ key: String,
        of elementType: Value.Type
    ) -> ObservablePref<AnyRawRepresentablePrefKey<Value, StorageValue>> {
        let keyInstance = AnyRawRepresentablePrefKey<Value, StorageValue>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `RawRepresentable` value with a default value.
    public func pref<Value: RawRepresentable, StorageValue: PrefStorageValue>(
        _ key: String,
        of elementType: Value.Type,
        default defaultValue: Value
    ) -> ObservableDefaultedPref<AnyDefaultedRawRepresentablePrefKey<Value, StorageValue>> {
        let keyInstance = AnyDefaultedRawRepresentablePrefKey<Value, StorageValue>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    // MARK: - Codable
    
    /// Synthesize a pref key with an `Codable` value.
    @_disfavoredOverload
    public func pref<Value: Codable, StorageValue: PrefStorageValue, Encoder: TopLevelEncoder, Decoder: TopLevelDecoder>(
        _ key: String,
        of elementType: Value.Type,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) -> ObservablePref<AnyCodablePrefKey<Value, StorageValue, Encoder, Decoder>> {
        let keyInstance = AnyCodablePrefKey<Value, StorageValue, Encoder, Decoder>(
            key: key,
            encoder: encoder(),
            decoder: decoder()
        )
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Codable` value with a default value.
    @_disfavoredOverload
    public func pref<Value: Codable, StorageValue: PrefStorageValue, Encoder: TopLevelEncoder, Decoder: TopLevelDecoder>(
        _ key: String,
        of elementType: Value.Type,
        default defaultValue: Value,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) -> ObservableDefaultedPref<AnyDefaultedCodablePrefKey<Value, StorageValue, Encoder, Decoder>> {
        let keyInstance = AnyDefaultedCodablePrefKey<Value, StorageValue, Encoder, Decoder>(
            key: key,
            defaultValue: defaultValue,
            encoder: encoder(),
            decoder: decoder()
        )
        return pref(keyInstance)
    }
    
    // MARK: - JSON Codable
    
    /// Synthesize a pref key with an `Codable` value using JSON encoding.
    @_disfavoredOverload
    public func pref<Value: Codable>(
        _ key: String,
        of elementType: Value.Type
    ) -> ObservablePref<AnyJSONCodablePrefKey<Value>> {
        let keyInstance = AnyJSONCodablePrefKey<Value>(
            key: key
        )
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Codable` value using JSON encoding with a default value.
    @_disfavoredOverload
    public func pref<Value: Codable>(
        _ key: String,
        of elementType: Value.Type,
        default defaultValue: Value
    ) -> ObservableDefaultedPref<AnyDefaultedJSONCodablePrefKey<Value>> {
        let keyInstance = AnyDefaultedJSONCodablePrefKey<Value>(
            key: key,
            defaultValue: defaultValue
        )
        return pref(keyInstance)
    }
}
