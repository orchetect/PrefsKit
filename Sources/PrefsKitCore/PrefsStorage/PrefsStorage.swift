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
    
    func setValue<Value: PrefStorageValue>(forKey key: String, to value: Value?)
    
    // MARK: - Get
    
    func value(forKey key: String) -> Int?
    func value(forKey key: String) -> String?
    func value(forKey key: String) -> Bool?
    func value(forKey key: String) -> Double?
    func value(forKey key: String) -> Float?
    func value(forKey key: String) -> Data?
    func value(forKey key: String) -> [any PrefStorageValue]?
    func value(forKey key: String) -> [String: any PrefStorageValue]?
    // func value<Element: PrefStorageValue>(forKey key: String) -> [Element]?
    // func value<Element: PrefStorageValue>(forKey key: String) -> [String: Element]?
    // func value(forKey key: String) -> AnyPrefArray?
    // func value(forKey key: String) -> AnyPrefDictionary?
}
