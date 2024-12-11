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
    public func setValue<Key>(to value: Key.StorageValue?, forKey key: Key) where Key: PrefsCodable {
        root[key.key] = value
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable {
        root[key.key] as? Key.StorageValue
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Int {
        root[key.key] as? Int
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == String {
        root[key.key] as? String
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Bool {
        root[key.key] as? Bool
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Double {
        root[key.key] as? Double
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Float {
        root[key.key] as? Float
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == Data {
        root[key.key] as? Data
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == [any PrefStorageValue] {
        root[key.key] as? [any PrefStorageValue]
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == [String: any PrefStorageValue] {
        root[key.key] as? [String: any PrefStorageValue]
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefsCodable, Element: PrefStorageValue, Key.StorageValue == [Element] {
        root[key.key] as? [Element]
    }
    
    public func value<Key, Element>(forKey key: Key) -> Key.StorageValue?
    where Key: PrefsCodable, Element: PrefStorageValue, Key.StorageValue == [String: Element] {
        root[key.key] as? [String: Element]
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == AnyPrefArray {
        root[key.key] as? AnyPrefArray
    }
    
    public func value<Key>(forKey key: Key) -> Key.StorageValue? where Key: PrefsCodable, Key.StorageValue == AnyPrefDictionary {
        root[key.key] as? AnyPrefDictionary
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
