//
//  PrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-09-25.
//

import Foundation

public protocol PrefKey<StorageValue>: Sendable where StorageValue: PrefStorageValue {
    associatedtype StorageValue: Hashable
    
    /// UserDefaults key name.
    var key: String { get }
    
    /// Returns the current value stored in UserDefaults.
    /// Returns nil if the key does not exist.
    func getValue() -> StorageValue?
}

// MARK: - Set

extension PrefKey {
    public func set(value: StorageValue?) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

// MARK: - Get

extension PrefKey {
    public func getValue() -> StorageValue? where StorageValue == Int {
        UserDefaults.standard.integerOptional(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == String {
        UserDefaults.standard.string(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == Bool {
        UserDefaults.standard.boolOptional(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == Double {
        UserDefaults.standard.doubleOptional(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == Float {
        UserDefaults.standard.floatOptional(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == Data {
        UserDefaults.standard.data(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == [Any] {
        UserDefaults.standard.array(forKey: key)
    }
    
    public func getValue() -> StorageValue? where StorageValue == [String: Any] {
        UserDefaults.standard.dictionary(forKey: key)
    }
}
