//
//  PrefsStorage.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-12-04.
//

import Foundation

/// Conform a type to enable it to be used for prefs storage.
public protocol PrefsStorage {
    func setValue<Key: PrefKey>(to value: Key.StorageValue?, forKey key: Key)
    
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Data
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [PrefStorageValue]
    func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: PrefStorageValue]
}
