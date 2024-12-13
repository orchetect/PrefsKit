//
//  PrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
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
    func storageValue(forKey key: String) -> [any PrefsStorageValue]?
    func storageValue(forKey key: String) -> [String: any PrefsStorageValue]?
    // func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]?
    // func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]?
    // func storageValue(forKey key: String) -> AnyPrefArray?
    // func storageValue(forKey key: String) -> AnyPrefDictionary?
}
