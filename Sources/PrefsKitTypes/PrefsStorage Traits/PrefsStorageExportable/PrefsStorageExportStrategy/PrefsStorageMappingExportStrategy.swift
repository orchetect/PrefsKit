//
//  PrefsStorageMappingExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageMappingExportStrategy: PrefsStorageExportStrategy {
    // MARK: - Atomic Types
    func exportValue(forKeyPath keyPath: [String], value: Int) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: String) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Bool) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Double) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Float) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Data) throws -> Any
    func exportValue(forKeyPath keyPath: [String], value: Date) throws -> Any
    
    // MARK: - Additional Types
    
    func exportValue(forKeyPath keyPath: [String], value: NSNumber) throws -> Any
}

// MARK: - Default Implementation

extension PrefsStorageExportStrategy where Self: PrefsStorageMappingExportStrategy {
    public func prepareForExport(storage: [String: Any]) throws -> [String: Any] {
        // start recursive call at root
        try prepareForExport(keyPath: [], dict: storage)
    }
    
    func prepareForExport(keyPath: [String], dict: [String: Any]) throws -> [String: Any] {
        var copy = dict
        
        for (key, value) in copy {
            var keyPath = keyPath
            keyPath.append(key)
            copy[key] = try prepareForExport(keyPath: keyPath, element: value)
        }
        
        return copy
    }
    
    func prepareForExport(keyPath: [String], array: [Any]) throws -> Any {
        try array.map { try prepareForExport(keyPath: keyPath, element: $0) }
    }
    
    func prepareForExport(keyPath: [String], element: Any) throws -> Any {
        switch element {
        case let v as String:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Bool where "\(type(of: element))" == "__NSCFBoolean":
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Int:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Bool:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Double:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Float:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Data:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as Date:
            try exportValue(forKeyPath: keyPath, value: v)
        case let v as [Any]:
            try prepareForExport(keyPath: keyPath, array: v)
        case let v as [String: Any]:
            try prepareForExport(keyPath: keyPath, dict: v)
        case let v as NSNumber:
            try exportValue(forKeyPath: keyPath, value: v)
        default:
            element
        }
    }
}
