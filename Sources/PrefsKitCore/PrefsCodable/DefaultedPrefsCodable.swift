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
    func getDefaultedValue(in storage: PrefsStorage) -> Value
}

extension DefaultedPrefsCodable {
    public func getDefaultedValue(in storage: PrefsStorage) -> Value {
        getValue(in: storage) ?? defaultValue
    }
}

// extension DefaultedPrefsCodable where StorageValue == Int {
//    public func getDefaultedValue(from storage: PrefsStorage) -> Int {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == String {
//    public func getDefaultedValue(from storage: PrefsStorage) -> String {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Bool {
//    public func getDefaultedValue(from storage: PrefsStorage) -> Bool {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Double {
//    public func getDefaultedValue(from storage: PrefsStorage) -> Double {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Float {
//    public func getDefaultedValue(from storage: PrefsStorage) -> Float {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == Data {
//    public func getDefaultedValue(from storage: PrefsStorage) -> Data {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == [Any] {
//    public func getDefaultedValue(from storage: PrefsStorage) -> [Any] {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }

// extension DefaultedPrefsCodable where StorageValue == [String: Any] {
//    public func getDefaultedValue(from storage: PrefsStorage) -> [String: Any] {
//        getStorageValue(in: storage) ?? defaultValue
//    }
// }
