//
//  PrefsStorageExportFormat.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageExportFormat { }

// MARK: - Format Traits

public protocol PrefsStorageExportFormatDataExportable where Self: PrefsStorageExportFormat {
    func exportData(storage: [String: Any]) throws -> Data
}

public protocol PrefsStorageExportFormatFileExportable where Self: PrefsStorageExportFormat {
    func export(storage: [String: Any], to file: URL) throws
}

public protocol PrefsStorageExportFormatStringExportable where Self: PrefsStorageExportFormat {
    func exportString(storage: [String: Any]) throws -> String
}

// MARK: - Default Implementation

extension PrefsStorageExportFormat where Self: PrefsStorageExportFormatDataExportable, Self: PrefsStorageExportFormatFileExportable {
    public func export(storage: [String: Any], to file: URL) throws {
        let data = try exportData(storage: storage)
        try data.write(to: file)
    }
}
