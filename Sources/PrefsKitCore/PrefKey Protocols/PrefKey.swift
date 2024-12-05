//
//  PrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// The foundational pref key protocol all other pref key protocols conform to.
/// Provides the core implementation requirements for read and write access of a key's value.
/// The underlying storage data type may be the same or different than the type vended by the main `getValue` and `setValue` methods.
public protocol PrefKey<Value, StorageValue>: Sendable
where StorageValue: PrefStorageValue {
    associatedtype Value
    associatedtype StorageValue
    
    /// Unique preference key name.
    var key: String { get }
    
    /// Returns the current stored value.
    /// Returns `nil` if the key does not exist.
    func getValue(in storage: PrefsStorage) -> Value?
    
    /// Stores a new value for the key.
    func setValue(to newValue: Value?, in storage: PrefsStorage)
    
    /// Returns the current raw storage value.
    /// Returns `nil` if the key does not exist.
    func getStorageValue(in storage: PrefsStorage) -> StorageValue?
    
    /// Stores a new raw storage value for the key.
    func setStorageValue(to newValue: StorageValue?, in storage: PrefsStorage)
}

extension PrefKey where Value == StorageValue {
    public func getValue(in storage: PrefsStorage) -> Value? {
        getStorageValue(in: storage)
    }
    
    public func setValue(to newValue: Value?, in storage: PrefsStorage) {
        setStorageValue(to: newValue, in: storage)
    }
}

extension PrefKey {
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == Int {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == String {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == Bool {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == Double {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == Float {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == Data {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == [any PrefStorageValue] {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == [String: any PrefStorageValue] {
        storage.value(forKey: self)
    }
    
    public func getStorageValue<Element: PrefStorageValue>(in storage: PrefsStorage) -> StorageValue? where StorageValue == [Element] {
        storage.value(forKey: self)
    }
    
    public func getStorageValue<Element: PrefStorageValue>(in storage: PrefsStorage) -> StorageValue? where StorageValue == [String: Element] {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == AnyPrefArray {
        storage.value(forKey: self)
    }
    
    public func getStorageValue(in storage: PrefsStorage) -> StorageValue? where StorageValue == AnyPrefDictionary {
        storage.value(forKey: self)
    }
}

extension PrefKey {
    public func setStorageValue(to newValue: StorageValue?, in storage: PrefsStorage) {
        storage.setValue(to: newValue, forKey: self)
    }
}
