//
//  PrefsStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol adopted by atomic value types that are valid for storage in UserDefaults.
public protocol PrefsStorageValue where Self: Equatable, Self: Sendable {
    associatedtype StorageValue
    var prefsStorageValue: StorageValue { get }
    var userDefaultsStorageValue: Any { get }
}

extension Int: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension String: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension Bool: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension Double: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension Float: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension Data: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension AnyPrefsArray: PrefsStorageValue {
    public var prefsStorageValue: [any PrefsStorageValue] {
        content.map { $0.value }
    }
    public var userDefaultsStorageValue: Any {
        content.map { $0.userDefaultsValue }
    }
}

extension AnyPrefsDictionary: PrefsStorageValue {
    public var prefsStorageValue: [String: any PrefsStorageValue] {
        content.mapValues { $0.value }
    }
    public var userDefaultsStorageValue: Any {
        content.mapValues { $0.userDefaultsValue }
    }
}

extension Array: PrefsStorageValue where Element: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension Dictionary: PrefsStorageValue where Key == String, Value: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
    public var userDefaultsStorageValue: Any { self }
}

extension NSNumber: PrefsStorageValue {
    public var prefsStorageValue: NSNumber { self }
    public var userDefaultsStorageValue: Any { self }
}
