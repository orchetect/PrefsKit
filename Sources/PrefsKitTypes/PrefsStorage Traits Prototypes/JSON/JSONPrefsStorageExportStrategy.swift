//
//  JSONPrefsStorageExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public struct JSONPrefsStorageExportStrategy {
    public typealias DataMapping = (_ keyPath: [String], _ date: Data) throws -> Any
    public var dataMapping: DataMapping
    
    public typealias DateMapping = (_ keyPath: [String], _ date: Date) throws -> Any
    public var dateMapping: DateMapping
    
    public init(
        data: @escaping DataMapping,
        date: @escaping DateMapping
    ) {
        self.dataMapping = data
        self.dateMapping = date
    }
}

extension JSONPrefsStorageExportStrategy: PrefsStorageMappingExportStrategy {
    public func exportValue(forKeyPath keyPath: [String], value: Int) throws -> Any {
        value
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: String) throws -> Any {
        value
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: Bool) throws -> Any {
        value
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: Double) throws -> Any {
        value
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: Float) throws -> Any {
        value
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: Data) throws -> Any {
        try dataMapping(keyPath, value)
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: Date) throws -> Any {
        try dateMapping(keyPath, value)
    }
    
    public func exportValue(forKeyPath keyPath: [String], value: NSNumber) throws -> Any {
        value
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportStrategy where Self == JSONPrefsStorageExportStrategy {
    public static func json(
        data: @escaping JSONPrefsStorageExportStrategy.DataMapping,
        date: @escaping JSONPrefsStorageExportStrategy.DateMapping
    ) -> JSONPrefsStorageExportStrategy {
        JSONPrefsStorageExportStrategy(
            data: data,
            date: date
        )
    }
}
