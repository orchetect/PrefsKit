//
//  DictionaryPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Dictionary-backed ``PrefsStorage`` with internally-synchronized dictionary access.
open class DictionaryPrefsStorage {
    @SynchronizedLock
    var storage: [String: any PrefsStorageValue]
    
    /// Local dictionary storage in memory.
    public var root: [String: any PrefsStorageValue] {
        get { storage }
        _modify { yield &storage }
        set { storage = newValue }
    }
    
    public init(root: [String: any PrefsStorageValue] = [:]) {
        storage = root
    }
}

extension DictionaryPrefsStorage: @unchecked Sendable { }

extension DictionaryPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        root[key] = value
    }
    
    public func setStorageValue(forKey key: String, to value: [any PrefsStorageValue]?) {
        if let value {
            root[key] = AnyPrefsArray(value)
        } else {
            root[key] = nil
        }
    }
    
    public func setStorageValue(forKey key: String, to value: [String: any PrefsStorageValue]?) {
        if let value {
            root[key] = AnyPrefsDictionary(value)
        } else {
            root[key] = nil
        }
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        root[key] as? Int
    }
    
    public func storageValue(forKey key: String) -> String? {
        root[key] as? String
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        root[key] as? Bool
    }
    
    public func storageValue(forKey key: String) -> Double? {
        root[key] as? Double
    }
    
    public func storageValue(forKey key: String) -> Float? {
        root[key] as? Float
    }
    
    public func storageValue(forKey key: String) -> Data? {
        root[key] as? Data
    }
    
    public func storageValue(forKey key: String) -> [any PrefsStorageValue]? {
        root[key] as? [any PrefsStorageValue]
    }
    
    public func storageValue(forKey key: String) -> [String: any PrefsStorageValue]? {
        root[key] as? [String: any PrefsStorageValue]
    }
    
    // MARK: - Additional type conversions
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        root[key] as? [Element]
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        root[key] as? [String: Element]
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsArray? {
        root[key] as? AnyPrefsArray
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsDictionary? {
        root[key] as? AnyPrefsDictionary
    }
}
