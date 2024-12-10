//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol for prefs schema.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol PrefsSchema where Self: Sendable {
    var storage: any PrefsStorage { get }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    public func pref<Key: PrefKey>(_ key: Key) -> ObservablePref<Key> {
        ObservablePref(key: key, storage: storage)
    }
    
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    public func pref<Key: DefaultedPrefKey>(_ key: Key) -> ObservableDefaultedPref<Key> {
        ObservableDefaultedPref(key: key, storage: storage)
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    // MARK: - Atomic
    
    /// Synthesize a pref key with an `Int` value.
    public func pref(
        int key: String
    ) -> ObservablePref<IntPrefKey> {
        let keyInstance = IntPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `String` value.
    public func pref(
        string key: String
    ) -> ObservablePref<StringPrefKey> {
        let keyInstance = StringPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value.
    public func pref(
        bool key: String
    ) -> ObservablePref<BoolPrefKey> {
        let keyInstance = BoolPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value.
    public func pref(
        double key: String
    ) -> ObservablePref<DoublePrefKey> {
        let keyInstance = DoublePrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value.
    public func pref(
        float key: String
    ) -> ObservablePref<FloatPrefKey> {
        let keyInstance = FloatPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value.
    public func pref(
        data key: String
    ) -> ObservablePref<DataPrefKey> {
        let keyInstance = DataPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref(
        array key: String
    ) -> ObservablePref<AnyArrayPrefKey> {
        let keyInstance = AnyArrayPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref<Element: PrefStorageValue>(
        array key: String,
        of elementType: Element.Type
    ) -> ObservablePref<ArrayPrefKey<Element>> {
        let keyInstance = ArrayPrefKey<Element>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref<Element: PrefStorageValue>(
        dictionary key: String,
        of elementType: Element.Type
    ) -> ObservablePref<DictionaryPrefKey<Element>> {
        let keyInstance = DictionaryPrefKey<Element>(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref(
        dictionary key: String
    ) -> ObservablePref<AnyDictionaryPrefKey> {
        let keyInstance = AnyDictionaryPrefKey(key: key)
        return pref(keyInstance)
    }
    
    // MARK: - Atomic Defaulted
    
    /// Synthesize a pref key with an `Int` value with a default value.
    public func pref(
        int key: String,
        default defaultValue: Int
    ) -> ObservableDefaultedPref<DefaultedIntPrefKey> {
        let keyInstance = DefaultedIntPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `String` value with a default value.
    public func pref(
        string key: String,
        default defaultValue: String
    ) -> ObservableDefaultedPref<DefaultedStringPrefKey> {
        let keyInstance = DefaultedStringPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value with a default value.
    public func pref(
        bool key: String,
        default defaultValue: Bool
    ) -> ObservableDefaultedPref<DefaultedBoolPrefKey> {
        let keyInstance = DefaultedBoolPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value with a default value.
    public func pref(
        double key: String,
        default defaultValue: Double
    ) -> ObservableDefaultedPref<DefaultedDoublePrefKey> {
        let keyInstance = DefaultedDoublePrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value with a default value.
    public func pref(
        float key: String,
        default defaultValue: Float
    ) -> ObservableDefaultedPref<DefaultedFloatPrefKey> {
        let keyInstance = DefaultedFloatPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value with a default value.
    public func pref(
        data key: String,
        default defaultValue: Data
    ) -> ObservableDefaultedPref<DefaultedDataPrefKey> {
        let keyInstance = DefaultedDataPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref(
        array key: String,
        default defaultValue: AnyPrefArray
    ) -> ObservableDefaultedPref<DefaultedAnyArrayPrefKey> {
        let keyInstance = DefaultedAnyArrayPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref<Element: PrefStorageValue>(
        array key: String,
        of elementType: Element.Type,
        default defaultValue: [Element]
    ) -> ObservableDefaultedPref<DefaultedArrayPrefKey<Element>> {
        let keyInstance = DefaultedArrayPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref(
        dictionary key: String,
        default defaultValue: AnyPrefDictionary
    ) -> ObservableDefaultedPref<DefaultedAnyDictionaryPrefKey> {
        let keyInstance = DefaultedAnyDictionaryPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref<Element: PrefStorageValue>(
        dictionary key: String,
        of elementType: Element.Type,
        default defaultValue: [String: Element]
    ) -> ObservableDefaultedPref<DefaultedDictionaryPrefKey<Element>> {
        let keyInstance = DefaultedDictionaryPrefKey(key: key, defaultValue: defaultValue)
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
    ) -> ObservableDefaultedPref<DefaultedAnyRawRepresentablePrefKey<Value, StorageValue>> {
        let keyInstance = DefaultedAnyRawRepresentablePrefKey<Value, StorageValue>(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
}
