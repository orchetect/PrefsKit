//
//  PrefsStorageImportFormat.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageImportFormat { }

// MARK: - Format Traits

public protocol PrefsStorageImportFormatDataImportable where Self: PrefsStorageImportFormat {
    func load(from data: Data) throws -> [String: Any]
}

public protocol PrefsStorageImportFormatFileImportable where Self: PrefsStorageImportFormat {
    func load(from file: URL) throws -> [String: Any]
}

public protocol PrefsStorageImportFormatStringImportable where Self: PrefsStorageImportFormat {
    func load(from string: String) throws -> [String: Any]
}

// MARK: - Default Implementation

extension PrefsStorageImportFormat where Self: PrefsStorageImportFormatDataImportable, Self: PrefsStorageImportFormatFileImportable {
    public func load(from file: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: file)
        let dict = try load(from: data)
        return dict
    }
}
