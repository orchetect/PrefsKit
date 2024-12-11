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

extension UserDefaultsPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setValue<Value: PrefStorageValue>(forKey key: String, to value: Value?) {
        suite.set(value?.prefStorageValue, forKey: key)
    }
    
    // MARK: - Get
    
    public func value(forKey key: String) -> Int? {
        suite.integerOptional(forKey: key)
    }
    
    public func value(forKey key: String) -> String? {
        suite.string(forKey: key)
    }
    
    public func value(forKey key: String) -> Bool? {
        suite.boolOptional(forKey: key)
    }
    
    public func value(forKey key: String) -> Double? {
        suite.doubleOptional(forKey: key)
    }
    
    public func value(forKey key: String) -> Float? {
        suite.floatOptional(forKey: key)
    }
    
    public func value(forKey key: String) -> Data? {
        suite.data(forKey: key)
    }
    
    public func value(forKey key: String) -> [any PrefStorageValue]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray.convertToAnyPrefArray()
        return typedArray.content.map(\.value)
    }
    
    public func value(forKey key: String) -> [String: any PrefStorageValue]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict.convertToAnyPrefDict()
        return typedDict.content.mapValues(\.value)
    }
    
    // MARK: - Additional type conversions
    // TODO: Implement these in library or refactor to somewhere elsewhere
    
    public func value<Element: PrefStorageValue>(forKey key: String) -> [Element]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray.compactMap { $0 as? Element }
        assert(typedArray.count == rawArray.count)
        return typedArray
    }
    
    public func value<Element: PrefStorageValue>(forKey key: String) -> [String: Element]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict.compactMapValues { $0 as? Element }
        assert(typedDict.count == rawDict.count)
        return typedDict
    }
    
    public func value(forKey key: String) -> AnyPrefArray? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray.convertToAnyPrefArray()
        assert(typedArray.content.count == rawArray.count)
        return typedArray
    }
    
    public func value(forKey key: String) -> AnyPrefDictionary? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
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
