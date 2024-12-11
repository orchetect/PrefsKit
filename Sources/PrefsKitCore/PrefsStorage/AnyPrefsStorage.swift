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
    public func setValue<Key>(to value: Key.StorageValue?, forKey key: Key) where Key: PrefsCodable {
        wrapped.setValue(to: value, forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Int {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == String {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Bool {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Double {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Float {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Data {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefsCodable, Key.StorageValue == [any PrefStorageValue] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefsCodable, Key.StorageValue == [String: any PrefStorageValue] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefsCodable, Element: PrefStorageValue, Key.StorageValue == [Element] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefsCodable, Element: PrefStorageValue, Key.StorageValue == [String: Element] {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == AnyPrefArray {
        wrapped.value(forKey: key)
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable,
    Key.StorageValue == AnyPrefDictionary {
        wrapped.value(forKey: key)
    }
}
