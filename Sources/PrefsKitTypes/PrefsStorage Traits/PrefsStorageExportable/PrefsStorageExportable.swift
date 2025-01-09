//
//  PrefsStorageExportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables exporting storage contents.
public protocol PrefsStorageExportable where Self: PrefsStorage {
    func dictionaryRepresentation() throws -> [String: Any]
    
    func export<Format: PrefsStorageExportFormat>(
        format: Format,
        to fileURL: URL
    ) throws where Format: PrefsStorageExportFormatFileExportable
    
    func exportData<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> Data where Format: PrefsStorageExportFormatDataExportable
    
    func exportString<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> String where Format: PrefsStorageExportFormatStringExportable
}

extension PrefsStorage where Self: PrefsStorageExportable {
    public func export<Format: PrefsStorageExportFormat>(
        format: Format,
        to fileURL: URL
    ) throws where Format: PrefsStorageExportFormatFileExportable {
        try format.export(storage: dictionaryRepresentation(), to: fileURL)
    }
    
    public func exportData<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> Data where Format: PrefsStorageExportFormatDataExportable {
        try format.exportData(storage: dictionaryRepresentation())
    }
    
    public func exportString<Format: PrefsStorageExportFormat>(
        format: Format
    ) throws -> String where Format: PrefsStorageExportFormatStringExportable {
        try format.exportString(storage: dictionaryRepresentation())
    }
}
