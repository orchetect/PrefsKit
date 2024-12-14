//
//  UserDefaultsPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

open class UserDefaultsPrefsStorage {
    public let suite: UserDefaults
    
    public init(suite: UserDefaults = .standard) {
        self.suite = suite
    }
}

extension UserDefaultsPrefsStorage: @unchecked Sendable { }

extension UserDefaultsPrefsStorage {
    public func setStorageValue(forKey key: String, to value: AnyPrefsArray?) {
        setStorageValue(forKey: key, to: value?.prefsStorageValue)
    }
    
    public func setStorageValue(forKey key: String, to value: AnyPrefsDictionary?) {
        setStorageValue(forKey: key, to: value?.prefsStorageValue)
    }
}

extension UserDefaultsPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        suite.set(value?.userDefaultsStorageValue, forKey: key)
    }
    
    public func setStorageValue(forKey key: String, to value: [any PrefsStorageValue]?) {
        suite.set(value, forKey: key)
    }
    
    public func setStorageValue(forKey key: String, to value: [String: any PrefsStorageValue]?) {
        suite.set(value, forKey: key)
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        suite.integerOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> String? {
        suite.string(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        suite.boolOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Double? {
        suite.doubleOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Float? {
        suite.floatOptional(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Data? {
        suite.data(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> [any PrefsStorageValue]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray.convertUserDefaultsToAnyPrefsArray()
        return typedArray.content.map(\.value)
    }
    
    public func storageValue(forKey key: String) -> [String: any PrefsStorageValue]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict.convertUserDefaultsToAnyPrefDict()
        return typedDict.content.mapValues(\.value)
    }
    
    // MARK: - Additional type conversions
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray
            .compactMap { $0 as? Element }
        assert(typedArray.count == rawArray.count)
        return typedArray
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict
            .compactMapValues { $0 as? Element }
        assert(typedDict.count == rawDict.count)
        return typedDict
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsArray? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray.convertUserDefaultsToAnyPrefsArray()
        assert(typedArray.content.count == rawArray.count)
        return typedArray
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsDictionary? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict.convertUserDefaultsToAnyPrefDict()
        assert(typedDict.content.count == rawDict.count)
        return typedDict
    }
}

// MARK: - Utilities

/// Convert a raw array from UserDefaults to a one that conforms to ``PrefsStorageValue``.
extension [Any] {
    func convertUserDefaultsToAnyPrefsArray() -> AnyPrefsArray {
        let converted = compactMap(AnyPrefsStorageValue.init(userDefaultsValue:))
        assert(converted.count == count)
        return AnyPrefsArray(converted)
    }
}

/// Convert a raw dictionary from UserDefaults to a one that conforms to ``PrefsStorageValue``.
extension [String: Any] {
    func convertUserDefaultsToAnyPrefDict() -> AnyPrefsDictionary {
        let converted = compactMapValues(AnyPrefsStorageValue.init(userDefaultsValue:))
        assert(converted.count == count)
        return AnyPrefsDictionary(converted)
    }
}
