//
//  JSONPrefsStorageImportFormat.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public struct JSONPrefsStorageImportFormat: PrefsStorageImportFormat {
    public var options: JSONSerialization.ReadingOptions
    
    public var strategy: any PrefsStorageImportStrategy
    
    public init(
        options: JSONSerialization.ReadingOptions = [],
        strategy: any PrefsStorageImportStrategy
    ) {
        self.options = options
        self.strategy = strategy
    }
}

// MARK: - Static Constructor

extension PrefsStorageImportFormat where Self == JSONPrefsStorageImportFormat {
    public static func json(
        options: JSONSerialization.ReadingOptions = [],
        strategy: any PrefsStorageImportStrategy
    ) -> JSONPrefsStorageImportFormat {
        JSONPrefsStorageImportFormat(options: options, strategy: strategy)
    }
}

// MARK: - Format Traits

extension JSONPrefsStorageImportFormat: PrefsStorageImportFormatFileImportable {
    // Note:
    // default implementation is provided when we conform to both
    // PrefsStorageImportFormatFileImportable & PrefsStorageImportFormatDataImportable
}

extension JSONPrefsStorageImportFormat: PrefsStorageImportFormatDataImportable {
    public func load(from data: Data) throws -> [String: Any] {
        let loaded: [String: Any] = try .init(json: data, options: options)
        let prepared = try strategy.prepareForImport(storage: loaded)
        return prepared
    }
}

extension JSONPrefsStorageImportFormat: PrefsStorageImportFormatStringImportable {
    public func load(from string: String) throws -> [String: Any] {
        let loaded: [String: Any] = try .init(json: string, options: options)
        let prepared = try strategy.prepareForImport(storage: loaded)
        return prepared
    }
}
