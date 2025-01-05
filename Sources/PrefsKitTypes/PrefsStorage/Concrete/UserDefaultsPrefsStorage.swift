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

extension UserDefaultsPrefsStorage: PrefsStorage {
    // MARK: - Set
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        switch value {
        case let v as AnyPrefsStorageValue?:
            suite.set(v?.unwrappedForUserDefaults, forKey: key)
        case let v as [AnyPrefsStorageValue]?:
            suite.set(v?.unwrappedForUserDefaults, forKey: key)
        case let v as [String: AnyPrefsStorageValue]?:
            suite.set(v?.unwrappedForUserDefaults, forKey: key)
        case let v as [String: [String: AnyPrefsStorageValue]]?:
            suite.set(v?.mapValues(\.unwrappedForUserDefaults), forKey: key)
        default:
            suite.set(value, forKey: key)
        }
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
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray as? [Element]
        return typedArray
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict as? [String: Element]
        return typedDict
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsStorageValue]? {
        guard let rawArray = suite.array(forKey: key) else { return nil }
        let typedArray = rawArray.convertUserDefaultsToAnyPrefsArray(allowHomogenousCasting: false)
        return typedArray
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsStorageValue]? {
        guard let rawDict = suite.dictionary(forKey: key) else { return nil }
        let typedDict = rawDict.convertUserDefaultsToAnyPrefDict(allowHomogenousCasting: false)
        return typedDict
    }
}
