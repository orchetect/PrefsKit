//
//  PrefKey Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - AtomicPrefKey

/// Pref key with `Int` value.
public struct IntPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = Int
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `String` value.
public struct StringPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = String
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Bool` value.
public struct BoolPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = Bool
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Double` value.
public struct DoublePrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = Double
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Float` value.
public struct FloatPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = Float
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Data` value.
public struct DataPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = Data
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Array` value.
public struct AnyArrayPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = AnyPrefArray
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Array` value.
public struct ArrayPrefKey<Element: PrefStorageValue>: AtomicPrefKey {
    public let key: String
    public typealias Value = [Element]
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Dictionary` value.
public struct AnyDictionaryPrefKey: AtomicPrefKey {
    public let key: String
    public typealias Value = AnyPrefDictionary
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Dictionary` value.
public struct DictionaryPrefKey<Element: PrefStorageValue>: AtomicPrefKey {
    public let key: String
    public typealias Value = [String: Element]
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Dictionary` value.
public struct AnyRawRepresentablePrefKey<
    Value: RawRepresentable,
    StorageValue: PrefStorageValue
>: PrefKey where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    
    public init(key: String) {
        self.key = key
    }
}

// MARK: - AtomicDefaultedPrefKey

/// Pref key with `Int` value.
public struct DefaultedIntPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = Int
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `String` value.
public struct DefaultedStringPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = String
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Bool` value.
public struct DefaultedBoolPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = Bool
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Double` value.
public struct DefaultedDoublePrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = Double
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Float` value.
public struct DefaultedFloatPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = Float
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Data` value.
public struct DefaultedDataPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = Data
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Array` value.
public struct DefaultedAnyArrayPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = AnyPrefArray
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Array` value.
public struct DefaultedArrayPrefKey<Element: PrefStorageValue>: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = [Element]
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Dictionary` value.
public struct DefaultedAnyDictionaryPrefKey: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = AnyPrefDictionary
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Dictionary` value.
public struct DefaultedDictionaryPrefKey<Element: PrefStorageValue>: AtomicDefaultedPrefKey {
    public let key: String
    public typealias Value = [String: Element]
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Dictionary` value.
public struct DefaultedAnyRawRepresentablePrefKey<
    Value: RawRepresentable,
    StorageValue: PrefStorageValue
>: DefaultedPrefKey where Value: Sendable, Value.RawValue == StorageValue {
    public let key: String
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
