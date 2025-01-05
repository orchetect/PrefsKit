//
//  UserDefaultsPrefsStorage+AnyPrefsStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorageValue {
    @inlinable
    init?(userDefaultsValue value: Any, allowHomogenousCasting: Bool = true) {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefsStorageValue` and allow
        // the user to conditionally cast it as the number type they desire.
        
        switch value {
        // MARK: Same-Type Pass-Through
        case let value as AnyPrefsStorageValue:
            self = value
            
        // MARK: Atomic
        case let value as NSString:
            self = .string(value as String)
        case let value as Bool where "\(type(of: value))" == "__NSCFBoolean":
            self = .bool(value)
        case let value as NSNumber:
            self = .number(value)
        case let value as NSData:
            self = .data(value as Data)
            
        // MARK: Arrays
        case let value as [NSString]:
            self = allowHomogenousCasting
                ? .stringArray(value as [String])
                : .anyArray(value.map { .string($0 as String) })
        case let value as [Bool] where value.allSatisfy({"\(type(of: $0))" == "__NSCFBoolean"}):
            self = allowHomogenousCasting
                ? .boolArray(value)
                : .anyArray(value.map { .bool($0) })
        case let value as [NSNumber]:
            self = allowHomogenousCasting
                ? .numberArray(value)
                : .anyArray(value.map { .number($0) })
        case let value as [NSData]:
            self = allowHomogenousCasting
                ? .dataArray(value as [Data])
                : .anyArray(value.map { .data($0 as Data) })
        case let value as [AnyPrefsStorageValue]:
            self = .anyArray(value)
        case let value as [Any]:
            self = .anyArray(value.convertUserDefaultsToAnyPrefsArray())
            
        // MARK: Dictionaries
        case let value as [NSString: NSString]:
            self = allowHomogenousCasting
                ? .stringDictionary(value as [String: String])
                : .anyDictionary((value as [String: String]).mapValues { .string($0) })
        case let value as [NSString: Bool] where value.values.allSatisfy({"\(type(of: $0))" == "__NSCFBoolean"}):
            self = allowHomogenousCasting
                ? .boolDictionary(value as [String: Bool])
                : .anyDictionary((value as [String: Bool]).mapValues { .bool($0) })
        case let value as [NSString: NSNumber]:
            self = allowHomogenousCasting
                ? .numberDictionary(value as [String: NSNumber])
                : .anyDictionary((value as [String: NSNumber]).mapValues { .number($0) })
        case let value as [NSString: NSData]:
            self = allowHomogenousCasting
                ? .dataDictionary(value as [String: Data])
                : .anyDictionary((value as [String: Data]).mapValues { .data($0) })
        case let value as [String: AnyPrefsStorageValue]:
            self = .anyDictionary(value)
        case let value as [String: Any]:
            self = .anyDictionary(value.convertUserDefaultsToAnyPrefDict())
            
            // MARK: Default
        default:
            assertionFailure("Unhandled UserDefaults pref storage value type: \(type(of: value))")
            return nil
        }
    }
    
    var unwrappedForUserDefaults: Any {
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
            array.unwrappedForUserDefaults
        case .boolArray(let array):
            array
        case .dataArray(let array):
            array
        case .numberArray(let array):
            array
        case .stringArray(let array):
            array
        case .anyDictionary(let dictionary):
            dictionary.unwrappedForUserDefaults
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

// MARK: - Utilities

extension [Any] {
    /// Convert a raw array from UserDefaults to a one that conforms to ``PrefsStorageValue``.
    @usableFromInline
    func convertUserDefaultsToAnyPrefsArray(allowHomogenousCasting: Bool = true) -> [AnyPrefsStorageValue] {
        let converted = compactMap {
            AnyPrefsStorageValue(userDefaultsValue: $0, allowHomogenousCasting: allowHomogenousCasting)
        }
        assert(converted.count == count)
        return converted
    }
}

extension [String: Any] {
    /// Convert a raw dictionary from UserDefaults to a one that conforms to ``PrefsStorageValue``.
    @usableFromInline
    func convertUserDefaultsToAnyPrefDict(allowHomogenousCasting: Bool = true) -> [String: AnyPrefsStorageValue] {
        let converted = compactMapValues {
            AnyPrefsStorageValue(userDefaultsValue: $0, allowHomogenousCasting: allowHomogenousCasting)
        }
        assert(converted.count == count)
        return converted
    }
}

extension [AnyPrefsStorageValue] {
    var unwrappedForUserDefaults: [Any] {
        map(\.unwrappedForUserDefaults)
    }
}

extension [String: AnyPrefsStorageValue] {
    var unwrappedForUserDefaults: [String: Any] {
        mapValues(\.unwrappedForUserDefaults)
    }
}
