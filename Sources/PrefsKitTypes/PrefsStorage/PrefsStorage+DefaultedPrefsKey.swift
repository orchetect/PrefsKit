//
//  PrefsStorage+DefaultedPrefsKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// swiftformat:disable wrap

// MARK: - Get Value

extension PrefsStorage {
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Int {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == String {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Bool {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Double {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Float {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == Data {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> Key.Value where Key.StorageValue == [Element] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey, Element: PrefsStorageValue>(forKey key: Key) -> Key.Value where Key.StorageValue == [String: Element] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == [AnyPrefsStorageValue] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == [String: AnyPrefsStorageValue] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
}
