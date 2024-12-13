//
//  AnyPrefsStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box for prefs storage values.
public enum AnyPrefsStorageValue {
    case number(NSNumber)
    case string(String)
    case bool(Bool)
    case data(Data)
    case array(AnyPrefsArray)
    case dictionary(AnyPrefsDictionary)
    
    @usableFromInline
    init?(_ value: any PrefsStorageValue) {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefsStorageValue` and allow
        // the user to conditionally cast it as the number type they desire.
        
        switch value {
        case let value as String:
            self = .string(value as String)
        case let value as Bool:
            self = .bool(value)
        case let value as Int:
            self = .number(value as NSNumber)
        case let value as Double:
            self = .number(value as NSNumber)
        case let value as Float:
            self = .number(value as NSNumber)
        case let value as NSData:
            self = .data(value as Data)
        case let value as [Any]:
            self = .array(value.convertToAnyPrefsArray())
        case let value as [String: Any]:
            self = .dictionary(value.convertToAnyPrefDict())
        case let value as [any PrefsStorageValue]:
            self = .array(AnyPrefsArray(value))
        case let value as [String: any PrefsStorageValue]:
            self = .dictionary(AnyPrefsDictionary(value))
        case let value as AnyPrefsArray:
            self = .array(value)
        case let value as AnyPrefsDictionary:
            self = .dictionary(value)
        default:
            print("Unhandled pref storage value type: \(type(of: value))")
            return nil
        }
    }
    
    @usableFromInline
    init?(userDefaultsValue value: Any) {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefsStorageValue` and allow
        // the user to conditionally cast it as the number type they desire.
        
        switch value {
        case let value as NSString:
            self = .string(value as String)
        case let value as Bool where "\(type(of: value))" == "__NSCFBoolean":
            self = .bool(value)
        case let value as NSNumber:
            self = .number(value)
        case let value as NSData:
            self = .data(value as Data)
        case let value as [Any]:
            self = .array(value.convertToAnyPrefsArray())
        case let value as [String: Any]:
            self = .dictionary(value.convertToAnyPrefDict())
        // case let value as any PrefsStorageValue:
        //     self = value
        default:
            print("Unhandled pref storage value type: \(type(of: value))")
            return nil
        }
    }
    
    public var value: any PrefsStorageValue {
        switch self {
        case let .number(nsNumber):
            nsNumber
        case let .string(string):
            string
        case let .bool(bool):
            bool
        case let .data(data):
            data
        case let .array(anyPrefsArray):
            anyPrefsArray
        case let .dictionary(anyPrefsDictionary):
            anyPrefsDictionary
        }
    }
}

extension AnyPrefsStorageValue: Equatable { }

extension AnyPrefsStorageValue: Sendable { }
