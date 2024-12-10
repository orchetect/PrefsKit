//
//  PrefKey Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// Generic concrete pref key with an atomic value type.
public struct AnyAtomicPrefKey<Value>: AtomicPrefKey where Value: Sendable, Value: PrefStorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = Value
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with an atomic value type and a default value.
public struct AnyDefaultedAtomicPrefKey<Value>: AtomicDefaultedPrefKey where Value: Sendable, Value: PrefStorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = Value
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Generic concrete pref key with a `RawRepresentable` value type.
public struct AnyRawRepresentablePrefKey<
    Value: RawRepresentable,
    StorageValue: PrefStorageValue
>: RawRepresentablePrefKey where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    
    public init(key: String) {
        self.key = key
    }
}

/// Generic concrete pref key with a `RawRepresentable` value type and a default value.
public struct AnyDefaultedRawRepresentablePrefKey<
    Value: RawRepresentable,
    StorageValue: PrefStorageValue
>: DefaultedRawRepresentablePrefKey where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
