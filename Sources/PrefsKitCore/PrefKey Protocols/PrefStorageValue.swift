//
//  PrefStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol adopted by atomic value types that are valid for storage in UserDefaults.
public protocol PrefStorageValue where Self: Equatable, Self: Sendable {
    associatedtype StorageValue
    var prefStorageValue: StorageValue { get }
}

extension Int: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension String: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension Bool: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension Double: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension Float: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension Data: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension AnyPrefArray: PrefStorageValue {
    public var prefStorageValue: [Any] {
        content.map { $0.value.prefStorageValue }
    }
}
extension AnyPrefDictionary: PrefStorageValue {
    public var prefStorageValue: [String: Any] {
        content.mapValues { $0.value.prefStorageValue }
    }
}
extension Array: PrefStorageValue where Element: PrefStorageValue {
    public var prefStorageValue: Self { self }
}
extension Dictionary: PrefStorageValue where Key == String, Value: PrefStorageValue {
    public var prefStorageValue: Self { self }
}

extension NSNumber: PrefStorageValue {
    public var prefStorageValue: NSNumber { self }
}
