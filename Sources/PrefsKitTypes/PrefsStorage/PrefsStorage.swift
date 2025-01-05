//
//  PrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Conform a type to enable it to be used for prefs storage.
/// The type must be a reference type (class).
public protocol PrefsStorage: AnyObject where Self: Sendable {
    // MARK: - Set
    
    func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?)
    
    // MARK: - Get
    
    func storageValue(forKey key: String) -> Int?
    func storageValue(forKey key: String) -> String?
    func storageValue(forKey key: String) -> Bool?
    func storageValue(forKey key: String) -> Double?
    func storageValue(forKey key: String) -> Float?
    func storageValue(forKey key: String) -> Data?
    func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]?
    func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]?
    func storageValue(forKey key: String) -> [AnyPrefsStorageValue]?
    func storageValue(forKey key: String) -> [String: AnyPrefsStorageValue]?
}
