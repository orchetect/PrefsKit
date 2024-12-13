//
//  PrefsStorage+PrefsKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// swiftformat:disable wrap

extension PrefsStorage {
    public func setValue<Key: PrefsKey>(forKey key: Key, to value: Key.Value?) {
        setStorageValue(forKey: key.key, to: key.encode(value))
    }
}

extension PrefsStorage {
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [any PrefsStorageValue] {
        storageValue(forKey: key.key)
    }
    
    public func storageValue<Key: PrefsKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: any PrefsStorageValue] {
        storageValue(forKey: key.key)
    }
}

extension PrefsStorage {
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Int {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == String {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Bool {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Double {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == Float {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == [any PrefsStorageValue] {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
    
    public func value<Key: PrefsKey>(forKey key: Key) -> Key.Value? where Key.StorageValue == [String: any PrefsStorageValue] {
        guard let storageValue = storageValue(forKey: key) else { return nil }
        return key.decode(storageValue)
    }
}
