//
//  UserDefaults+PrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Conform any `UserDefaults` suite (including `standard`) so it can implicitly be used as a prefs storage backend.
extension UserDefaults: PrefsStorage {
    // MARK: - Set
    
    public func setValue<Key: PrefKey>(to value: Key.StorageValue?, forKey key: Key) {
        set(value, forKey: key.key)
    }
    
    // MARK: - Get
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Int {
        integerOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == String {
        string(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Bool {
        boolOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Double {
        doubleOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Float {
        floatOptional(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == Data {
        data(forKey: key.key)
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [any PrefStorageValue] {
        guard let rawArray = array(forKey: key.key) else { return nil }
        let typedArray: [any PrefStorageValue] = rawArray.convertToPrefArray()
        assert(typedArray.count == rawArray.count)
        return typedArray
    }
    
    public func value<Key: PrefKey>(forKey key: Key) -> Key.StorageValue? where Key.StorageValue == [String: any PrefStorageValue] {
        guard let rawDict = dictionary(forKey: key.key) else { return nil }
        let typedDict: [String: any PrefStorageValue] = rawDict.convertToPrefDict()
        assert(typedDict.count == rawDict.count)
        return typedDict
    }
}

// MARK: - Utilities

/// Convert a raw value from UserDefaults to a type that conforms to ``PrefStorageValue``.
fileprivate func convertToPrefValue(_ value: Any) -> (any PrefStorageValue)? {
    // Note that underlying number format of NSNumber can't easily be determined
    // so the cleanest solution is to make NSNumber `PrefStorageValue` and allow
    // the user to conditionally cast it as the number type they desire.
    
    switch value {
    case let value as NSString: return value as String
    case let value as Bool where "\(type(of: value))" == "__NSCFBoolean": return value
    case let value as NSNumber: return value
    case let value as NSData: return value as Data
    case let value as [Any]: return value.convertToPrefArray()
    case let value as [String: Any]: return value.convertToPrefDict()
    case let value as PrefStorageValue: return value
    default:
        print("Unhandled pref storage value type: \(type(of: value))")
        return nil
    }
}

/// Convert a raw array from UserDefaults to a one that conforms to ``PrefStorageValue``.
extension [Any] {
    fileprivate func convertToPrefArray() -> [any PrefStorageValue] {
        compactMap { convertToPrefValue($0) }
    }
}

/// Convert a raw dictionary from UserDefaults to a one that conforms to ``PrefStorageValue``.
extension [String: Any] {
    fileprivate func convertToPrefDict() -> [String: any PrefStorageValue] {
        compactMapValues { convertToPrefValue($0) }
    }
}
