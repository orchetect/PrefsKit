//
//  PrefsStorage+DefaultedPrefsKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

// swiftformat:disable wrap

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
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == [any PrefsStorageValue] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
    
    public func value<Key: DefaultedPrefsKey>(forKey key: Key) -> Key.Value where Key.StorageValue == [String: any PrefsStorageValue] {
        key.decodeDefaulted(storageValue(forKey: key))
    }
}
