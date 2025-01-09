//
//  PrefsStorageImportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageImportStrategy {
    func prepareForImport(storage: [String: Any]) throws -> [String: Any]
    
    // MARK: - Atomic Types
    func importValue(forKeyPath keyPath: [String], value: Int) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: String) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Bool) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Double) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Float) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Data) throws -> any PrefsStorageValue
    func importValue(forKeyPath keyPath: [String], value: Date) throws -> any PrefsStorageValue
    
    // MARK: - Additional Types
    func importValue(forKeyPath keyPath: [String], value: NSNumber) throws -> any PrefsStorageValue
}

// MARK: - Default Implementation

extension PrefsStorageImportStrategy {
    public func prepareForImport(storage: [String: Any]) throws -> [String: Any] {
        // start recursive call at root
        try prepareForImport(keyPath: [], dict: storage)
    }
    
    func prepareForImport(keyPath: [String], dict: [String: Any]) throws -> [String: Any] {
        var copy = dict
        
        for (key, value) in copy {
            var keyPath = keyPath
            keyPath.append(key)
            copy[key] = try prepareForImport(keyPath: keyPath, element: value)
        }
        
        return copy
    }
    
    func prepareForImport(keyPath: [String], array: [Any]) throws -> Any {
        try array.map { try prepareForImport(keyPath: keyPath, element: $0) }
    }
    
    func prepareForImport(keyPath: [String], element: Any) throws -> Any {
        switch element {
        case let v as String:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Bool where "\(type(of: element))" == "__NSCFBoolean":
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Int:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Bool:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Double:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Float:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Data:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as Date:
            try importValue(forKeyPath: keyPath, value: v)
        case let v as [Any]:
            try prepareForImport(keyPath: keyPath, array: v)
        case let v as [String: Any]:
            try prepareForImport(keyPath: keyPath, dict: v)
        case let v as NSNumber:
            try importValue(forKeyPath: keyPath, value: v)
        default:
            element
        }
    }
}

extension PrefsStorageImportStrategy {
    // MARK: - Atomic Types
    
    public func importValue(forKeyPath keyPath: [String], value: Int) throws -> any PrefsStorageValue {
        value
    }

    public func importValue(forKeyPath keyPath: [String], value: String) throws -> any PrefsStorageValue {
        value
    }

    public func importValue(forKeyPath keyPath: [String], value: Bool) throws -> any PrefsStorageValue {
        value
    }

    public func importValue(forKeyPath keyPath: [String], value: Double) throws -> any PrefsStorageValue {
        value
    }

    public func importValue(forKeyPath keyPath: [String], value: Float) throws -> any PrefsStorageValue {
        value
    }

    public func importValue(forKeyPath keyPath: [String], value: Data) throws -> any PrefsStorageValue {
        value
    }

    public func importValue(forKeyPath keyPath: [String], value: Date) throws -> any PrefsStorageValue {
        value
    }
    
    // MARK: - Additional Types
    
    public func importValue(forKeyPath keyPath: [String], value: NSNumber) throws -> any PrefsStorageValue {
        switch value {
        case let v as Int: v
        case let v as Bool: v
        case let v as Double: v
        case let v as Float: v
        default: value
        }
    }
}
