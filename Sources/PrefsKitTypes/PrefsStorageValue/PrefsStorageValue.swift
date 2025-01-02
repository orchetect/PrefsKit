//
//  PrefsStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol adopted by atomic value types that are valid for storage in UserDefaults.
public protocol PrefsStorageValue where Self: Equatable, Self: Sendable {
    associatedtype StorageValue
    var prefsStorageValue: StorageValue { get }
    var userDefaultsStorageValue: Any { get }
}
