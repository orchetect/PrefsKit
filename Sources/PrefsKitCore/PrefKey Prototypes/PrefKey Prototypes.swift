//
//  PrefKey Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - BasicPrefKey

/// Pref key with `Int` value.
public struct IntPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = Int
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `String` value.
public struct StringPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = String
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Bool` value.
public struct BoolPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = Bool
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Double` value.
public struct DoublePrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = Double
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Float` value.
public struct FloatPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = Float
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Data` value.
public struct DataPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = Data
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Array` value.
public struct ArrayPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = [any PrefStorageValue]
    
    public init(key: String) {
        self.key = key
    }
}

/// Pref key with `Dictionary` value.
public struct DictionaryPrefKey: BasicPrefKey {
    public let key: String
    public typealias Value = [String: any PrefStorageValue]
    
    public init(key: String) {
        self.key = key
    }
}

// MARK: - BasicDefaultedPrefKey

/// Pref key with `Int` value.
public struct DefaultedIntPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = Int
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `String` value.
public struct DefaultedStringPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = String
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Bool` value.
public struct DefaultedBoolPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = Bool
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Double` value.
public struct DefaultedDoublePrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = Double
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Float` value.
public struct DefaultedFloatPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = Float
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Data` value.
public struct DefaultedDataPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = Data
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Array` value.
public struct DefaultedArrayPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = [any PrefStorageValue]
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

/// Pref key with `Dictionary` value.
public struct DefaultedDictionaryPrefKey: BasicDefaultedPrefKey {
    public let key: String
    public typealias Value = [String: any PrefStorageValue]
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
