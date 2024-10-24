//
//  PrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-09-25.
//

import Foundation

public protocol PrefKey where Self: Sendable {
    associatedtype Value
    
    /// UserDefaults key name.
    var key: String { get }
    
    /// Returns the current value stored in UserDefaults.
    /// Returns nil if the key does not exist.
    func getValue() -> Value?
}

extension PrefKey {
    public func set(value: Value?) {
        UserDefaults.standard.set(value, forKey: key)
    }
}

extension PrefKey where Value == Int {
    public func getValue() -> Value? {
        UserDefaults.standard.integerOptional(forKey: key)
    }
}

extension PrefKey where Value == String {
    public func getValue() -> Value? {
        UserDefaults.standard.string(forKey: key)
    }
}

extension PrefKey where Value == Bool {
    public func getValue() -> Value? {
        UserDefaults.standard.boolOptional(forKey: key)
    }
}

extension PrefKey where Value == Double {
    public func getValue() -> Value? {
        UserDefaults.standard.doubleOptional(forKey: key)
    }
}

extension PrefKey where Value == Float {
    public func getValue() -> Value? {
        UserDefaults.standard.floatOptional(forKey: key)
    }
}

extension PrefKey where Value == Data {
    public func getValue() -> Value? {
        UserDefaults.standard.data(forKey: key)
    }
}

extension PrefKey where Value == [Any] {
    public func getValue() -> Value? {
        UserDefaults.standard.array(forKey: key)
    }
}

extension PrefKey where Value == [String: Any] {
    public func getValue() -> Value? {
        UserDefaults.standard.dictionary(forKey: key)
    }
}
