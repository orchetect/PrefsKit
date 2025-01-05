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
        switch value {
        case let v as AnyPrefsStorageValue?:
            root[key] = v?.unwrapped
        default:
            root[key] = value
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
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        root[key] as? [Element]
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        root[key] as? [String: Element]
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsStorageValue]? {
        (root[key] as? [Any])?
            .convertUserDefaultsToAnyPrefsArray(allowHomogenousCasting: false)
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsStorageValue]? {
        (root[key] as? [String: Any])?
            .convertUserDefaultsToAnyPrefDict(allowHomogenousCasting: false)
    }
}
