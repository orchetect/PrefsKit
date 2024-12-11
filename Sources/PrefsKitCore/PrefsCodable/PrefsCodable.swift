//
//  PrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// The foundational pref key protocol all other pref key protocols conform to.
///
/// Provides the core implementation requirements for read and write access of a key's value.
///
/// The underlying atomic storage data type may be the same or different than the type vended by
/// the main `getValue` and `setValue` methods.
public protocol PrefsCodable<Value, StorageValue>: Sendable
where Value: Sendable, StorageValue: PrefStorageValue {
    associatedtype Value
    associatedtype StorageValue
    
    /// Returns the current stored value.
    /// Returns `nil` if the key does not exist.
    func getValue(forKey key: String, in storage: PrefsStorage) -> Value?
    
    /// Stores a new value for the key.
    func setValue(forKey key: String, to newValue: Value?, in storage: PrefsStorage)
    
    /// Returns the current raw storage value.
    /// Returns `nil` if the key does not exist.
    func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue?
    
    /// Stores a new raw storage value for the key.
    func setStorageValue(forKey key: String, to newValue: StorageValue?, in storage: PrefsStorage)
}

extension PrefsCodable where Value == StorageValue {
    public func getValue(forKey key: String, in storage: PrefsStorage) -> Value? {
        getStorageValue(forKey: key, in: storage)
    }
    
    public func setValue(forKey key: String, to newValue: Value?, in storage: PrefsStorage) {
        setStorageValue(forKey: key, to: newValue, in: storage)
    }
}

extension PrefsCodable {
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? {
        fatalError("Prefs storage value type not handled: \(type(of: StorageValue.self))")
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == Int {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == String {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == Bool {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == Double {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == Float {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == Data {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == [any PrefStorageValue] {
        storage.value(forKey: key)
    }
    
    public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == [String: any PrefStorageValue] {
        storage.value(forKey: key)
    }
    
    // TODO: implement these or delete
    
    // public func getStorageValue<Element: PrefStorageValue>(forKey key: String, in storage: PrefsStorage) -> StorageValue?
    // where StorageValue == [Element] {
    //     storage.value(forKey: key)
    // }
    //
    // public func getStorageValue<Element: PrefStorageValue>(forKey key: String, in storage: PrefsStorage) -> StorageValue?
    // where StorageValue == [String: Element] {
    //     storage.value(forKey: key)
    // }
    //
    // public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == AnyPrefArray {
    //     storage.value(forKey: key)
    // }
    //
    // public func getStorageValue(forKey key: String, in storage: PrefsStorage) -> StorageValue? where StorageValue == AnyPrefDictionary {
    //     storage.value(forKey: key)
    // }
}

extension PrefsCodable {
    public func setStorageValue(forKey key: String, to newValue: StorageValue?, in storage: PrefsStorage) {
        storage.setValue(forKey: key, to: newValue)
    }
}
