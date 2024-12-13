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
}

extension Int: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension String: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension Bool: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension Double: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension Float: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension Data: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension AnyPrefsArray: PrefsStorageValue {
    public var prefsStorageValue: [Any] {
        content.map { $0.value.prefsStorageValue }
    }
}

extension AnyPrefDictionary: PrefsStorageValue {
    public var prefsStorageValue: [String: Any] {
        content.mapValues { $0.value.prefsStorageValue }
    }
}

extension Array: PrefsStorageValue where Element: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension Dictionary: PrefsStorageValue where Key == String, Value: PrefsStorageValue {
    public var prefsStorageValue: Self { self }
}

extension NSNumber: PrefsStorageValue {
    public var prefsStorageValue: NSNumber { self }
}
