//
//  DictionaryPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Dictionary-backed ``PrefsStorage`` with internally-synchronized dictionary access.
public final class DictionaryPrefsStorage {
    @SynchronizedLock
    var storage: [String: any PrefStorageValue]
    
    public var root: [String: any PrefStorageValue] {
        get { storage }
        set { storage = newValue }
    }
    
    public init(root: [String: any PrefStorageValue] = [:]) {
        self.storage = root
    }
}

extension DictionaryPrefsStorage: @unchecked Sendable { }

extension DictionaryPrefsStorage: PrefsStorage {
    public func setValue<Key>(to value: Key.StorageValue?, forKey key: Key) where Key: PrefKey {
        root[key.key] = value
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey {
        root[key.key] as? Key.StorageValue
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Int {
        root[key.key] as? Int
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == String {
        root[key.key] as? String
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Bool {
        root[key.key] as? Bool
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Double {
        root[key.key] as? Double
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Float {
        root[key.key] as? Float
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Data {
        root[key.key] as? Data
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == [any PrefStorageValue] {
        root[key.key] as? [any PrefStorageValue]
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == [String: any PrefStorageValue] {
        root[key.key] as? [String: any PrefStorageValue]
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Element: PrefStorageValue, Key.StorageValue == [Element] {
        root[key.key] as? [Element]
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Element: PrefStorageValue, Key.StorageValue == [String: Element] {
        root[key.key] as? [String: Element]
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == AnyPrefArray {
        root[key.key] as? AnyPrefArray
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == AnyPrefDictionary {
        root[key.key] as? AnyPrefDictionary
    }
}
