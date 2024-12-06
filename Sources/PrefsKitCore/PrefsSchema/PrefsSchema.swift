//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol for prefs schema.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol PrefsSchema where Self: Sendable {
    associatedtype Key: RawRepresentable where Key.RawValue == String, Key: CaseIterable
    
    var storage: any PrefsStorage { get }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    @_disfavoredOverload
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
    // MARK: - Basic
    
    /// Synthesize a pref key with an `Int` value.
    public func pref(
        int key: Key
    ) -> ObservablePref<IntPrefKey> {
        let keyInstance = IntPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `String` value.
    public func pref(
        string key: Key
    ) -> ObservablePref<StringPrefKey> {
        let keyInstance = StringPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value.
    public func pref(
        bool key: Key
    ) -> ObservablePref<BoolPrefKey> {
        let keyInstance = BoolPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value.
    public func pref(
        double key: Key
    ) -> ObservablePref<DoublePrefKey> {
        let keyInstance = DoublePrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value.
    public func pref(
        float key: Key
    ) -> ObservablePref<FloatPrefKey> {
        let keyInstance = FloatPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value.
    public func pref(
        data key: Key
    ) -> ObservablePref<DataPrefKey> {
        let keyInstance = DataPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref(
        array key: Key
    ) -> ObservablePref<AnyArrayPrefKey> {
        let keyInstance = AnyArrayPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref<Element: PrefStorageValue>(
        array key: Key,
        of elementType: Element.Type
    ) -> ObservablePref<ArrayPrefKey<Element>> {
        let keyInstance = ArrayPrefKey<Element>(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref<Element: PrefStorageValue>(
        dictionary key: Key,
        of elementType: Element.Type
    ) -> ObservablePref<DictionaryPrefKey<Element>> {
        let keyInstance = DictionaryPrefKey<Element>(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref(
        dictionary key: Key
    ) -> ObservablePref<AnyDictionaryPrefKey> {
        let keyInstance = AnyDictionaryPrefKey(key: key.rawValue)
        return pref(keyInstance)
    }
    
    // MARK: - Basic Defaulted
    
    /// Synthesize a pref key with an `Int` value with a default value.
    public func pref(
        int key: Key,
        default defaultValue: Int
    ) -> ObservableDefaultedPref<DefaultedIntPrefKey> {
        let keyInstance = DefaultedIntPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `String` value with a default value.
    public func pref(
        string key: Key,
        default defaultValue: String
    ) -> ObservableDefaultedPref<DefaultedStringPrefKey> {
        let keyInstance = DefaultedStringPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value with a default value.
    public func pref(
        bool key: Key,
        default defaultValue: Bool
    ) -> ObservableDefaultedPref<DefaultedBoolPrefKey> {
        let keyInstance = DefaultedBoolPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value with a default value.
    public func pref(
        double key: Key,
        default defaultValue: Double
    ) -> ObservableDefaultedPref<DefaultedDoublePrefKey> {
        let keyInstance = DefaultedDoublePrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value with a default value.
    public func pref(
        float key: Key,
        default defaultValue: Float
    ) -> ObservableDefaultedPref<DefaultedFloatPrefKey> {
        let keyInstance = DefaultedFloatPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value with a default value.
    public func pref(
        data key: Key,
        default defaultValue: Data
    ) -> ObservableDefaultedPref<DefaultedDataPrefKey> {
        let keyInstance = DefaultedDataPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref(
        array key: Key,
        default defaultValue: AnyPrefArray
    ) -> ObservableDefaultedPref<DefaultedAnyArrayPrefKey> {
        let keyInstance = DefaultedAnyArrayPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref<Element: PrefStorageValue>(
        array key: Key,
        of elementType: Element.Type,
        default defaultValue: [Element]
    ) -> ObservableDefaultedPref<DefaultedArrayPrefKey<Element>> {
        let keyInstance = DefaultedArrayPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref(
        dictionary key: Key,
        default defaultValue: AnyPrefDictionary
    ) -> ObservableDefaultedPref<DefaultedAnyDictionaryPrefKey> {
        let keyInstance = DefaultedAnyDictionaryPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref<Element: PrefStorageValue>(
        dictionary key: Key,
        of elementType: Element.Type,
        default defaultValue: [String: Element]
    ) -> ObservableDefaultedPref<DefaultedDictionaryPrefKey<Element>> {
        let keyInstance = DefaultedDictionaryPrefKey(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    // MARK: - RawRepresentable
    
    /// Synthesize a pref key with an `RawRepresentable` value.
    public func pref<Value: RawRepresentable, StorageValue: PrefStorageValue>(
        _ key: Key,
        of elementType: Value.Type
    ) -> ObservablePref<AnyRawRepresentablePrefKey<Value, StorageValue>> {
        let keyInstance = AnyRawRepresentablePrefKey<Value, StorageValue>(key: key.rawValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `RawRepresentable` value with a default value.
    public func pref<Value: RawRepresentable, StorageValue: PrefStorageValue>(
        _ key: Key,
        of elementType: Value.Type,
        default defaultValue: Value
    ) -> ObservableDefaultedPref<DefaultedAnyRawRepresentablePrefKey<Value, StorageValue>> {
        let keyInstance = DefaultedAnyRawRepresentablePrefKey<Value, StorageValue>(key: key.rawValue, defaultValue: defaultValue)
        return pref(keyInstance)
    }
}
