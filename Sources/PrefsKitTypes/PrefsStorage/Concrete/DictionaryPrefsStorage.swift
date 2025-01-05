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
        if let value = root[key] as? AnyPrefsArray {
            return value.prefsStorageValue
        }
        return root[key] as? [any PrefsStorageValue]
    }
    
    public func storageValue(forKey key: String) -> [String: any PrefsStorageValue]? {
        if let value = root[key] as? AnyPrefsDictionary {
            return value.prefsStorageValue
        }
        return root[key] as? [String: any PrefsStorageValue]
    }
    
    // MARK: - Additional type conversions
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        switch Element.self {
        case is AnyPrefsArray.Type: // TODO: only accounts for [AnyPrefsArray] but not [[AnyPrefsArray]] etc.
            guard let value: AnyPrefsArray = storageValue(forKey: key) else { return nil }
            return value.prefsStorageValue as? [Element]
        case is AnyPrefsDictionary.Type: // TODO: only accounts for [AnyPrefsDictionary] but not [[AnyPrefsDictionary]] etc.
            guard let value: AnyPrefsArray = storageValue(forKey: key) else { return nil }
            return value.prefsStorageValue as? [Element]
        default:
            if let value = root[key] as? [Element] {
                return value
            } else if let value: AnyPrefsArray = storageValue(forKey: key) {
                return value.content.map(\.userDefaultsValue) as? [Element]
            } else {
                return nil
            }
        }
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsArray]? {
        root[key] as? [AnyPrefsArray]
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsDictionary]? {
        root[key] as? [AnyPrefsDictionary]
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        switch Element.self {
        case is AnyPrefsArray.Type: // TODO: only accounts for [String: AnyPrefsArray] but not [String: [AnyPrefsArray]] etc.
            guard let value: AnyPrefsDictionary = storageValue(forKey: key) else { return nil }
            return value.prefsStorageValue as? [String: Element]
        case is AnyPrefsDictionary.Type: // TODO: only accounts for [String: AnyPrefsDictionary] but not [String: [AnyPrefsDictionary]] etc.
            guard let value: AnyPrefsDictionary = storageValue(forKey: key) else { return nil }
            return value.prefsStorageValue as? [String: Element]
        default:
            if let value = root[key] as? [String: Element] {
                return value
            } else if let value: AnyPrefsDictionary = storageValue(forKey: key) {
                return value.content.mapValues(\.userDefaultsValue) as? [String: Element]
            } else {
                return nil
            }
        }
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsArray]? {
        root[key] as? [String: AnyPrefsArray]
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsDictionary]? {
        root[key] as? [String: AnyPrefsDictionary]
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsArray? {
        root[key] as? AnyPrefsArray
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsDictionary? {
        root[key] as? AnyPrefsDictionary
    }
}
