//
//  DefaultedPrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that provides a default value.
public protocol DefaultedPrefsCodable: PrefsCodable {
    /// Default value to return if the key does not exist or its value is mismatched.
    var defaultValue: Value { get }
    
    /// Returns the current stored value.
    /// Returns the ``defaultValue`` if the key does not exist or its value is mismatched.
    func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Value
}

extension DefaultedPrefsCodable {
    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Value {
        getValue(forKey: key, in: storage) ?? defaultValue
    }
}

// extension DefaultedPrefsCodable where StorageValue == Int {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Int {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == String {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> String {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Bool {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Bool {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Double {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Double {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Float {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Float {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Data {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Data {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == [Any] {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> [Any] {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == [String: Any] {
//    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> [String: Any] {
//        getValue(forKey: key, in: storage) ?? defaultValue
//    }
// }
