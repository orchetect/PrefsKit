//
//  UserDefaultsPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
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
        let converted = value?.convertToUserDefaultsArray()
        suite.set(converted, forKey: key)
    }
    
    public func setStorageValue(forKey key: String, to value: [String: any PrefsStorageValue]?) {
        let converted = value?.convertToUserDefaultsDictionary()
        suite.set(converted, forKey: key)
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
        switch Element.self {
        case is AnyPrefsArray.Type: // TODO: only accounts for [AnyPrefsArray] but not [[AnyPrefsArray]] etc.
            let value: [AnyPrefsArray]? = storageValue(forKey: key)
            return value as! [Element]?
        case is AnyPrefsDictionary.Type: // TODO: only accounts for [AnyPrefsDictionary] but not [[AnyPrefsDictionary]] etc.
            let value: [AnyPrefsDictionary]? = storageValue(forKey: key)
            return value as! [Element]?
        default:
            guard let rawArray = suite.array(forKey: key) else { return nil }
            let typedArray = rawArray
                .compactMap { $0 as? Element }
            assert(typedArray.count == rawArray.count)
            return typedArray
        }
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsArray]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray
            .compactMap { $0 as? [any PrefsStorageValue] }
        let mappedArray = typedArray.map { AnyPrefsArray($0) }
        assert(mappedArray.count == rawArray.count)
        return mappedArray
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsDictionary]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray
            .compactMap { $0 as? [String: any PrefsStorageValue] }
        let mappedArray = typedArray.map { AnyPrefsDictionary($0) }
        assert(mappedArray.count == rawArray.count)
        return mappedArray
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        switch Element.self {
        case is AnyPrefsArray.Type: // TODO: only accounts for [String: AnyPrefsArray] but not [String: [AnyPrefsArray]] etc.
            let value: [String: AnyPrefsArray]? = storageValue(forKey: key)
            return value as! [String: Element]?
        case is AnyPrefsDictionary.Type: // TODO: only accounts for [AnyPrefsDictionary] but not [[AnyPrefsDictionary]] etc.
            let value: [String: AnyPrefsDictionary]? = storageValue(forKey: key)
            return value as! [String: Element]?
        default:
            guard let rawDict = suite.dictionary(forKey: key) else { return nil }
            let typedDict = rawDict
                .compactMapValues { $0 as? Element }
            assert(typedDict.count == rawDict.count)
            return typedDict
        }
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsArray]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict
            .compactMapValues { $0 as? [any PrefsStorageValue] }
        let mappedDict = typedDict.mapValues { AnyPrefsArray($0) }
        assert(mappedDict.count == rawDict.count)
        return mappedDict
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsDictionary]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict
            .compactMapValues { $0 as? [String: any PrefsStorageValue] }
        let mappedDict = typedDict.mapValues { AnyPrefsDictionary($0) }
        assert(mappedDict.count == rawDict.count)
        return mappedDict
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

extension [Any] {
    /// Convert a raw array from UserDefaults to a one that conforms to ``PrefsStorageValue``.
    func convertUserDefaultsToAnyPrefsArray() -> AnyPrefsArray {
        let converted = compactMap(AnyPrefsStorageValue.init(userDefaultsValue:))
        assert(converted.count == count)
        return AnyPrefsArray(converted)
    }
}

extension [String: Any] {
    /// Convert a raw dictionary from UserDefaults to a one that conforms to ``PrefsStorageValue``.
    func convertUserDefaultsToAnyPrefDict() -> AnyPrefsDictionary {
        let converted = compactMapValues(AnyPrefsStorageValue.init(userDefaultsValue:))
        assert(converted.count == count)
        return AnyPrefsDictionary(converted)
    }
}

extension [any PrefsStorageValue] {
    /// Convert an array that potentially has a mix of atomic prefs values (including ``AnyPrefsArray`` or
    /// ``AnyPrefsDictionary``) to one compatible with storage in UserDefaults.
    func convertToUserDefaultsArray() -> [Any] {
        let converted = compactMap(AnyPrefsStorageValue.init(_:))
            .map(\.userDefaultsValue)
        assert(converted.count == count)
        return converted
    }
}

extension [String: any PrefsStorageValue] {
    /// Convert a dictionary that potentially has a mix of atomic prefs values (including ``AnyPrefsArray`` or
    /// ``AnyPrefsDictionary``) to one compatible with storage in UserDefaults.
    func convertToUserDefaultsDictionary() -> [String: Any] {
        let converted = compactMapValues(AnyPrefsStorageValue.init(_:))
            .mapValues(\.userDefaultsValue)
        assert(converted.count == count)
        return converted
    }
}
