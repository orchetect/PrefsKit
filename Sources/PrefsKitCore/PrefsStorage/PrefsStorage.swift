//
//  PrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Conform a type to enable it to be used for prefs storage.
/// The type must be a reference type (class).
public protocol PrefsStorage: AnyObject where Self: Sendable {
    func setValue<Key: PrefsCodable>(to value: Key.StorageValue?, forKey key: Key)
    
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue?
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Data
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [any PrefStorageValue]
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: any PrefStorageValue]
    func value<Key: PrefsCodable, Element: PrefStorageValue>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [Element]
    func value<Key: PrefsCodable, Element: PrefStorageValue>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: Element]
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == AnyPrefArray
    func value<Key: PrefsCodable>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == AnyPrefDictionary
}
