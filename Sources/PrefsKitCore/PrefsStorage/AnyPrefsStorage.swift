//
//  AnyPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box containing an instance of a concrete class conforming to ``PrefsStorage``.
public final class AnyPrefsStorage: PrefsStorage {
    public let wrapped: any PrefsStorage
    
    public init(_ wrapped: any PrefsStorage) {
        self.wrapped = wrapped
    }
}

extension AnyPrefsStorage {
    public func setValue<Key>(to value: Key.StorageValue?, forKey key: Key) where Key: PrefKey {
        wrapped.setValue(to: value, forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Int {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == String {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Bool {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Double {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Float {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == Data {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefKey, Key.StorageValue == [any PrefStorageValue] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefKey, Key.StorageValue == [String: any PrefStorageValue] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefKey, Element: PrefStorageValue, Key.StorageValue == [Element] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefKey, Element: PrefStorageValue, Key.StorageValue == [String: Element] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey, Key.StorageValue == AnyPrefArray {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefKey,
    Key.StorageValue == AnyPrefDictionary {
        wrapped.value(forKey: key)
    }
}
