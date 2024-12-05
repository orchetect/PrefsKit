//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsSchema {
    associatedtype Storage: PrefsStorage
    var storage: Storage { get }
}

extension PrefsSchema {
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    @_disfavoredOverload
    public func pref<Key: PrefKey>(_ key: Key) -> PrefAndStorage<Key> {
        PrefAndStorage(key: key, storage: storage)
    }
    
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    public func pref<Key: DefaultedPrefKey>(_ key: Key) -> DefaultedPrefAndStorage<Key> {
        DefaultedPrefAndStorage(key: key, storage: storage)
    }
}

extension PrefsSchema {
    // MARK: - Basic
    
    /// Synthesize a pref key with an `Int` value.
    public func pref(
        int key: String
    ) -> PrefAndStorage<IntPrefKey> {
        let keyInstance = IntPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `String` value.
    public func pref(
        string key: String
    ) -> PrefAndStorage<StringPrefKey> {
        let keyInstance = StringPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value.
    public func pref(
        bool key: String
    ) -> PrefAndStorage<BoolPrefKey> {
        let keyInstance = BoolPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value.
    public func pref(
        double key: String
    ) -> PrefAndStorage<DoublePrefKey> {
        let keyInstance = DoublePrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value.
    public func pref(
        float key: String
    ) -> PrefAndStorage<FloatPrefKey> {
        let keyInstance = FloatPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value.
    public func pref(
        data key: String
    ) -> PrefAndStorage<DataPrefKey> {
        let keyInstance = DataPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value.
    public func pref(
        array key: String
    ) -> PrefAndStorage<ArrayPrefKey> {
        let keyInstance = ArrayPrefKey(key: key)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Dictionary` value.
    public func pref(
        dictionary key: String
    ) -> PrefAndStorage<DictionaryPrefKey> {
        let keyInstance = DictionaryPrefKey(key: key)
        return pref(keyInstance)
    }
    
    // MARK: - Basic Defaulted
    
    /// Synthesize a pref key with an `Int` value with a default value.
    public func pref(
        int key: String,
        default defaultValue: Int
    ) -> DefaultedPrefAndStorage<DefaultedIntPrefKey> {
        let keyInstance = DefaultedIntPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `String` value with a default value.
    public func pref(
        string key: String,
        default defaultValue: String
    ) -> DefaultedPrefAndStorage<DefaultedStringPrefKey> {
        let keyInstance = DefaultedStringPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Bool` value with a default value.
    public func pref(
        bool key: String,
        default defaultValue: Bool
    ) -> DefaultedPrefAndStorage<DefaultedBoolPrefKey> {
        let keyInstance = DefaultedBoolPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Double` value with a default value.
    public func pref(
        double key: String,
        default defaultValue: Double
    ) -> DefaultedPrefAndStorage<DefaultedDoublePrefKey> {
        let keyInstance = DefaultedDoublePrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Float` value with a default value.
    public func pref(
        float key: String,
        default defaultValue: Float
    ) -> DefaultedPrefAndStorage<DefaultedFloatPrefKey> {
        let keyInstance = DefaultedFloatPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with a `Data` value with a default value.
    public func pref(
        data key: String,
        default defaultValue: Data
    ) -> DefaultedPrefAndStorage<DefaultedDataPrefKey> {
        let keyInstance = DefaultedDataPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Array` value with a default value.
    public func pref(
        array key: String,
        default defaultValue: [any PrefStorageValue]
    ) -> DefaultedPrefAndStorage<DefaultedArrayPrefKey> {
        let keyInstance = DefaultedArrayPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
    
    /// Synthesize a pref key with an `Dictionary` value with a default value.
    public func pref(
        dictionary key: String,
        default defaultValue: [String: any PrefStorageValue]
    ) -> DefaultedPrefAndStorage<DefaultedDictionaryPrefKey> {
        let keyInstance = DefaultedDictionaryPrefKey(key: key, defaultValue: defaultValue)
        return pref(keyInstance)
    }
}
