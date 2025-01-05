//
//  AnyPrefsStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box for prefs storage values.
public enum AnyPrefsStorageValue {
    case bool(Bool)
    case data(Data)
    case number(NSNumber)
    case string(String)
    
    case anyArray([AnyPrefsStorageValue])
    case boolArray([Bool])
    case dataArray([Data])
    case numberArray([NSNumber])
    case stringArray([String])
    
    case anyDictionary([String: AnyPrefsStorageValue])
    case boolDictionary([String: Bool])
    case dataDictionary([String: Data])
    case numberDictionary([String: NSNumber])
    case stringDictionary([String: String])
}

extension AnyPrefsStorageValue {
    @inlinable
    public init?(_ value: any PrefsStorageValue, allowHomogenousCasting: Bool = true) {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefsStorageValue` and allow
        // the user to conditionally cast it as the number type they desire.
        
        switch value {
        // MARK: Same-Type Pass-Through
        case let value as AnyPrefsStorageValue:
            self = value
            
        // MARK: Atomic
        case let value as String:
            self = .string(value as String)
        case let value as Int:
            self = .number(value as NSNumber)
        case let value as Bool:
            self = .bool(value)
        case let value as Double:
            self = .number(value as NSNumber)
        case let value as Float:
            self = .number(value as NSNumber)
        case let value as NSData:
            self = .data(value as Data)
            
        // MARK: Arrays (Homogenous Value Type)
        case let value as [String]:
            self = allowHomogenousCasting
                ? .stringArray(value)
                : .anyArray(value.map { .string($0) })
        case let value as [NSNumber]:
            self = allowHomogenousCasting
                ? .numberArray(value)
                : .anyArray(value.map { .number($0) })
        case let value as [Bool]:
            self = allowHomogenousCasting
                ? .boolArray(value)
                : .anyArray(value.map { .bool($0) })
        case let value as [Data]:
            self = allowHomogenousCasting
                ? .dataArray(value)
                : .anyArray(value.map { .data($0) })
        case let value as [AnyPrefsStorageValue]:
            self = .anyArray(value)
            
        // MARK: Dictionaries (Homogenous Value Type)
        case let value as [String: String]:
            self = allowHomogenousCasting
                ? .stringDictionary(value)
                : .anyDictionary(value.mapValues { .string($0) })
        case let value as [String: NSNumber]:
            self = allowHomogenousCasting
                ? .numberDictionary(value)
                : .anyDictionary(value.mapValues { .number($0) })
        case let value as [String: Bool]:
            self = allowHomogenousCasting
                ? .boolDictionary(value)
                : .anyDictionary(value.mapValues { .bool($0) })
        case let value as [String: Data]:
            self = allowHomogenousCasting
                ? .dataDictionary(value)
                : .anyDictionary(value.mapValues { .data($0) })
        case let value as [String: AnyPrefsStorageValue]:
            self = .anyDictionary(value)
            
        // MARK: Default
        default:
            print("Unhandled pref storage value type: \(type(of: value))")
            return nil
        }
    }
    
    @inlinable @_disfavoredOverload
    public init(_ value: [any PrefsStorageValue]) {
        let mapped = value.compactMap { AnyPrefsStorageValue($0) }
        assert(mapped.count == value.count)
        self = .anyArray(mapped)
    }
    
    @inlinable @_disfavoredOverload
    public init(_ value: [String: any PrefsStorageValue]) {
        let mapped = value.compactMapValues { AnyPrefsStorageValue($0) }
        assert(mapped.count == value.count)
        self = .anyDictionary(mapped)
    }
}

extension AnyPrefsStorageValue: Equatable { }

extension AnyPrefsStorageValue: Hashable { }

extension AnyPrefsStorageValue: Sendable { }

// MARK: - Properties

extension AnyPrefsStorageValue {
    /// Returns the unwrapped value typed as ``PrefsStorageValue``.
    ///
    /// Note that arrays with mixed element types will be `[AnyPrefsStorageValue]` and dictionaries with mixed value
    /// types will be `[String: AnyPrefsStorageValue]`.
    @inlinable
    public var unwrapped: any PrefsStorageValue {
        switch self {
        case .bool(let bool):
            bool
        case .data(let data):
            data
        case .number(let nSNumber):
            nSNumber
        case .string(let string):
            string
        case .anyArray(let array):
            array
        case .boolArray(let array):
            array
        case .dataArray(let array):
            array
        case .numberArray(let array):
            array
        case .stringArray(let array):
            array
        case .anyDictionary(let dictionary):
            dictionary
        case .boolDictionary(let dictionary):
            dictionary
        case .dataDictionary(let dictionary):
            dictionary
        case .numberDictionary(let dictionary):
            dictionary
        case .stringDictionary(let dictionary):
            dictionary
        }
    }
}

// MARK: - Collection Methods

extension [any PrefsStorageValue] {
    /// Converts an array with mixed value types to one of type-erased ``AnyPrefsStorageValue`` values.
    public var asAnyPrefsStorageValues: [AnyPrefsStorageValue] {
        convertToAnyPrefsArray()
    }
}

extension [String: any PrefsStorageValue] {
    /// Converts a dictionary with mixed value types to one with type-erased ``AnyPrefsStorageValue`` values.
    public var asAnyPrefsStorageValues: [String: AnyPrefsStorageValue] {
        convertToAnyPrefsDict()
    }
}

extension [AnyPrefsStorageValue] {
    /// Returns the array with unwrapped values typed as ``PrefsStorageValue``.
    @inlinable
    public var unwrapped: [any PrefsStorageValue] {
        map(\.unwrapped)
    }
}

extension [String: AnyPrefsStorageValue] {
    /// Returns the array with unwrapped values typed as ``PrefsStorageValue``.
    @inlinable
    public var unwrapped: [String: any PrefsStorageValue] {
        mapValues(\.unwrapped)
    }
}

// MARK: - Utilities

extension [any PrefsStorageValue] {
    /// Convert an array with mixed value types that conform to ``PrefsStorageValue`` to
    /// `[AnyPrefsStorageValue]`.
    @usableFromInline
    func convertToAnyPrefsArray(allowHomogenousCasting: Bool = true) -> [AnyPrefsStorageValue] {
        let converted = compactMap {
            AnyPrefsStorageValue($0, allowHomogenousCasting: allowHomogenousCasting)
        }
        assert(converted.count == count)
        return converted
    }
}

extension [String: any PrefsStorageValue] {
    /// Convert a dictionary with mixed value types that conform to ``PrefsStorageValue`` to
    /// `[String: AnyPrefsStorageValue]`.
    @usableFromInline
    func convertToAnyPrefsDict(allowHomogenousCasting: Bool = true) -> [String: AnyPrefsStorageValue] {
        let converted = compactMapValues {
            AnyPrefsStorageValue($0, allowHomogenousCasting: allowHomogenousCasting)
        }
        assert(converted.count == count)
        return converted
    }
}
