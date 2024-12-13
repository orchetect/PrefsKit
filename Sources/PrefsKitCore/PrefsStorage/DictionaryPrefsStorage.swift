//
//  DictionaryPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Dictionary-backed ``PrefsStorage`` with internally-synchronized dictionary access.
open class DictionaryPrefsStorage {
    @SynchronizedLock
    var storage: [String: any PrefStorageValue]
    
    /// Local dictionary storage in memory.
    public var root: [String: any PrefStorageValue] {
        get { storage }
        _modify { yield &storage }
        set { storage = newValue }
    }
    
    public init(root: [String: any PrefStorageValue] = [:]) {
        storage = root
    }
}

extension DictionaryPrefsStorage: @unchecked Sendable { }

extension DictionaryPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefStorageValue>(forKey key: String, to value: StorageValue?) {
        root[key] = value
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
    
    public func storageValue(forKey key: String) -> [any PrefStorageValue]? {
        root[key] as? [any PrefStorageValue]
    }
    
    public func storageValue(forKey key: String) -> [String: any PrefStorageValue]? {
        root[key] as? [String: any PrefStorageValue]
    }
}

// MARK: - PList Interchange

extension DictionaryPrefsStorage {
    /// Replaces the local ``root`` dictionary with the contents of a plist file.
    public func load(plist url: URL) throws {
        root = try .init(plist: url)
    }
    
    /// Replaces the local ``root`` dictionary with the raw contents of a plist file.
    public func load(plist data: Data) throws {
        root = try .init(plist: data)
    }
    
    /// Saves the local ``root`` dictionary to a plist file.
    public func save(plist url: URL) throws {
        try root.plistData().write(to: url)
    }
    
    /// Returns the local ``root`` dictionary as raw plist file data.
    public func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try root.plistData(format: format)
    }
}
