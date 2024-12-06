//
//  AnyPrefStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum AnyPrefStorageValue {
    case number(NSNumber)
    case string(String)
    case bool(Bool)
    case data(Data)
    case array(AnyPrefArray)
    case dictionary(AnyPrefDictionary)
    
    init?(_ value: any PrefStorageValue) {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefStorageValue` and allow
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
            self = .array(value.convertToAnyPrefArray())
        case let value as [String: Any]:
            self = .dictionary(value.convertToAnyPrefDict())
        case let value as [any PrefStorageValue]:
            self = .array(AnyPrefArray(value))
        case let value as [String: any PrefStorageValue]:
            self = .dictionary(AnyPrefDictionary(value))
        case let value as AnyPrefArray:
            self = .array(value)
        case let value as AnyPrefDictionary:
            self = .dictionary(value)
        default:
            print("Unhandled pref storage value type: \(type(of: value))")
            return nil
        }
    }
    
    init?(userDefaultsValue value: Any) {
        // Note that underlying number format of NSNumber can't easily be determined
        // so the cleanest solution is to make NSNumber `PrefStorageValue` and allow
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
            self = .array(value.convertToAnyPrefArray())
        case let value as [String: Any]:
            self = .dictionary(value.convertToAnyPrefDict())
        // case let value as any PrefStorageValue:
        //     self = value
        default:
            print("Unhandled pref storage value type: \(type(of: value))")
            return nil
        }
    }
    
    public var value: any PrefStorageValue {
        switch self {
        case .number(let nsNumber):
            nsNumber
        case .string(let string):
            string
        case .bool(let bool):
            bool
        case .data(let data):
            data
        case .array(let anyPrefArray):
            anyPrefArray
        case .dictionary(let anyPrefDictionary):
            anyPrefDictionary
        }
    }
}

extension AnyPrefStorageValue: Equatable { }

extension AnyPrefStorageValue: Sendable { }