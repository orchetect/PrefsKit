//
//  UserDefaultsPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

public final class UserDefaultsPrefsStorage {
    public let suite: UserDefaults
    
    public init(suite: UserDefaults = .standard) {
        self.suite = suite
    }
}

extension UserDefaultsPrefsStorage: @unchecked Sendable { }

extension UserDefaultsPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setValue<Key: PrefKey>(to value: Key.StorageValue?, forKey key: Key) {
        suite.set(value?.prefStorageValue, forKey: key.key)
    }
    
    // MARK: - Get
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? {
        suite.value(forKey: key.key) as? Key.StorageValue
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int {
        suite.integerOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String {
        suite.string(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool {
        suite.boolOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double {
        suite.doubleOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float {
        suite.floatOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Data {
        suite.data(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [any PrefStorageValue] {
        guard let rawArray = suite.array(forKey: key.key) else { return nil }
        let typedArray = rawArray.convertToAnyPrefArray()
        return typedArray.content.map(\.value)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: any PrefStorageValue] {
        guard let rawDict = suite.dictionary(forKey: key.key) else { return nil }
        let typedDict = rawDict.convertToAnyPrefDict()
        return typedDict.content.mapValues(\.value)
    }
    
    public func value<Key: PrefKey, Element: PrefStorageValue>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [Element] {
        guard let rawArray = suite.array(forKey: key.key) else { return nil }
        let typedArray = rawArray.compactMap { $0 as? Element }
        assert(typedArray.count == rawArray.count)
        return typedArray
    }
    
    public func value<Key: PrefKey, Element: PrefStorageValue>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: Element] {
        guard let rawDict = suite.dictionary(forKey: key.key) else { return nil }
        let typedDict = rawDict.compactMapValues { $0 as? Element }
        assert(typedDict.count == rawDict.count)
        return typedDict
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == AnyPrefArray {
        guard let rawArray = suite.array(forKey: key.key) else { return nil }
        let typedArray = rawArray.convertToAnyPrefArray()
        assert(typedArray.content.count == rawArray.count)
        return typedArray
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == AnyPrefDictionary {
        guard let rawDict = suite.dictionary(forKey: key.key) else { return nil }
        let typedDict = rawDict.convertToAnyPrefDict()
        assert(typedDict.content.count == rawDict.count)
        return typedDict
    }
}

// MARK: - Utilities

/// Convert a raw array from UserDefaults to a one that conforms to ``PrefStorageValue``.
extension [Any] {
    func convertToAnyPrefArray() -> AnyPrefArray {
        let converted = compactMap { AnyPrefStorageValue(userDefaultsValue: $0) }
        assert(converted.count == count)
        return AnyPrefArray(converted)
    }
}

/// Convert a raw dictionary from UserDefaults to a one that conforms to ``PrefStorageValue``.
extension [String: Any] {
    func convertToAnyPrefDict() -> AnyPrefDictionary {
        let converted = compactMapValues { AnyPrefStorageValue(userDefaultsValue: $0) }
        assert(converted.count == count)
        return AnyPrefDictionary(converted)
    }
}
