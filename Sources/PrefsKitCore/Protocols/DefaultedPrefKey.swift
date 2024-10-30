//
//  DefaultedPrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

public protocol DefaultedPrefKey<StorageValue>: PrefKey {
    /// Default value to return if no UserDefaults key exists or its value is mismatched.
    var defaultValue: StorageValue { get }
    
    /// Returns the current value stored in UserDefaults.
    /// Returns the ``defaultValue`` if no UserDefaults key exists or its value is mismatched.
    func getValueDefaulted() -> StorageValue
}

 extension DefaultedPrefKey {
    public func getValueDefaulted() -> StorageValue {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == Int {
    public func getValueDefaulted() -> Int {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == String {
    public func getValueDefaulted() -> String {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == Bool {
    public func getValueDefaulted() -> Bool {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == Double {
    public func getValueDefaulted() -> Double {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == Float {
    public func getValueDefaulted() -> Float {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == Data {
    public func getValueDefaulted() -> Data {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == [Any] {
    public func getValueDefaulted() -> [Any] {
        getValue() ?? defaultValue
    }
 }

 extension DefaultedPrefKey where StorageValue == [String: Any] {
    public func getValueDefaulted() -> [String: Any] {
        getValue() ?? defaultValue
    }
 }
