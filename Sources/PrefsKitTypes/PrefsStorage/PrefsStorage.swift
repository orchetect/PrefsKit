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
    func setStorageValue(forKey key: String, to value: [any PrefsStorageValue]?)
    func setStorageValue(forKey key: String, to value: [String: any PrefsStorageValue]?)
    
    // MARK: - Get
    
    func storageValue(forKey key: String) -> Int?
    func storageValue(forKey key: String) -> String?
    func storageValue(forKey key: String) -> Bool?
    func storageValue(forKey key: String) -> Double?
    func storageValue(forKey key: String) -> Float?
    func storageValue(forKey key: String) -> Data?
    func storageValue(forKey key: String) -> [any PrefsStorageValue]?
    func storageValue(forKey key: String) -> [String: any PrefsStorageValue]?
    
    // Additional type conversions with default implementations
    func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]?
    func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]?
    func storageValue(forKey key: String) -> AnyPrefsArray?
    func storageValue(forKey key: String) -> AnyPrefsDictionary?
}

// MARK: - Additional type conversions

extension PrefsStorage {
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        switch Element.self {
        case is AnyPrefsArray.Type: // TODO: only accounts for [AnyPrefsArray] but not [[AnyPrefsArray]] etc.
            let value: [AnyPrefsArray]? = storageValue(forKey: key)
            return value as! [Element]?
        case is AnyPrefsDictionary.Type: // TODO: only accounts for [AnyPrefsDictionary] but not [[AnyPrefsDictionary]] etc.
            let value: [AnyPrefsDictionary]? = storageValue(forKey: key)
            return value as! [Element]?
        default:
            guard let storageValue: [any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
            let cast = storageValue.compactMap { $0 as? Element }
            assert(storageValue.count == cast.count)
            return cast
        }
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsArray]? {
        guard let storageValue: [any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
        let cast = storageValue.compactMap { $0 as? [any PrefsStorageValue] }
        let mapped = cast.map { AnyPrefsArray($0) }
        assert(storageValue.count == mapped.count)
        return mapped
    }
    
    public func storageValue(forKey key: String) -> [AnyPrefsDictionary]? {
        guard let storageValue: [any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
        let cast = storageValue.compactMap { $0 as? [String: any PrefsStorageValue] }
        let mapped = cast.map { AnyPrefsDictionary($0) }
        assert(storageValue.count == mapped.count)
        return mapped
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
            guard let storageValue: [String: any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
            let cast = storageValue.compactMapValues { $0 as? Element }
            assert(storageValue.count == cast.count)
            return cast
        }
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsArray]? {
        guard let storageValue: [String: any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
        let cast = storageValue.compactMapValues { $0 as? [any PrefsStorageValue] }
        let mapped = cast.compactMapValues { AnyPrefsArray($0) }
        assert(storageValue.count == mapped.count)
        return mapped
    }
    
    public func storageValue(forKey key: String) -> [String: AnyPrefsDictionary]? {
        guard let storageValue: [String: any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
        let cast = storageValue.compactMapValues { $0 as? [String: any PrefsStorageValue] }
        let mapped = cast.compactMapValues { AnyPrefsDictionary($0) }
        assert(storageValue.count == mapped.count)
        return mapped
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsArray? {
        guard let storageValue: [any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
        let anyArray = AnyPrefsArray(storageValue)
        return anyArray
    }
    
    public func storageValue(forKey key: String) -> AnyPrefsDictionary? {
        guard let storageValue: [String: any PrefsStorageValue] = storageValue(forKey: key) else { return nil }
        let anyDict = AnyPrefsDictionary(storageValue)
        return anyDict
    }
}
