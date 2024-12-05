//
//  UserDefaults+PrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Conform any `UserDefaults` suite (including `standard`) so it can implicitly be used as a prefs storage backend.
extension UserDefaults: PrefsStorage {
    // MARK: - Set
    
    public func setValue<Key: PrefKey>(to value: Key.StorageValue?, forKey key: Key) {
        set(value, forKey: key.key)
    }
    
    // MARK: - Get
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int {
        integerOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String {
        string(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool {
        boolOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double {
        doubleOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float {
        floatOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Data {
        data(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [any PrefStorageValue] {
        array(forKey: key.key) as? [any PrefStorageValue]
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: any PrefStorageValue] {
        dictionary(forKey: key.key) as? [String: any PrefStorageValue]
    }
}
