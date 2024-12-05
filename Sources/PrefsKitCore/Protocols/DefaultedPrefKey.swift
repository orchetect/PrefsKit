//
//  DefaultedPrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

/// A prefs key that provides a default value.
public protocol DefaultedPrefKey: PrefKey {
    /// Default value to return if the key does not exist or its value is mismatched.
    var defaultValue: Value { get }
    
    /// Returns the current stored value.
    /// Returns the ``defaultValue`` if the key does not exist or its value is mismatched.
    func getDefaultedValue(in storage: PrefsStorage) -> Value
}

 extension DefaultedPrefKey {
    public func getDefaultedValue(in storage: PrefsStorage) -> Value {
        getValue(in: storage) ?? defaultValue
    }
 }

 // extension DefaultedPrefKey where StorageValue == Int {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> Int {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == String {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> String {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == Bool {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> Bool {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == Double {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> Double {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == Float {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> Float {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == Data {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> Data {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == [Any] {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> [Any] {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }

 // extension DefaultedPrefKey where StorageValue == [String: Any] {
 //    public func getDefaultedValue(from storage: PrefsStorage) -> [String: Any] {
 //        getStorageValue(in: storage) ?? defaultValue
 //    }
 // }
