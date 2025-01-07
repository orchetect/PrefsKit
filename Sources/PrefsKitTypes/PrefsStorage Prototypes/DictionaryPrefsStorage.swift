//
//  DictionaryPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Dictionary-backed ``PrefsStorage`` with internally-synchronized dictionary access.
public final class DictionaryPrefsStorage {
    @SynchronizedLock
    var storage: [String: Any]
    
    /// Initialize from type-safe dictionary content.
    public init(root: [String: any PrefsStorageValue] = [:]) {
        storage = root
    }
    
    /// Initialize from raw untyped dictionary content.
    /// You are responsible for ensuring value types are compatible with related methods such as plist conversion.
    public init(unsafe storage: [String: Any]) {
        self.storage = storage
    }
}

extension DictionaryPrefsStorage: @unchecked Sendable { }

extension DictionaryPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        storage[key] = value
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        storage[key] as? Int
    }
    
    public func storageValue(forKey key: String) -> String? {
        storage[key] as? String
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        storage[key] as? Bool
    }
    
    public func storageValue(forKey key: String) -> Double? {
        storage[key] as? Double
    }
    
    public func storageValue(forKey key: String) -> Float? {
        storage[key] as? Float
    }
    
    public func storageValue(forKey key: String) -> Data? {
        storage[key] as? Data
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        storage[key] as? [Element]
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        storage[key] as? [String: Element]
    }
    
    public func storageValue(forKey key: String) -> [Any]? {
        storage[key] as? [Any]
    }
    
    public func storageValue(forKey key: String) -> [String: Any]? {
        storage[key] as? [String: Any]
    }
}

extension DictionaryPrefsStorage: _PrefsStorage {
    @_disfavoredOverload
    package func setStorageValue(forKey key: String, to value: Any) {
        storage[key] = value
    }
}
