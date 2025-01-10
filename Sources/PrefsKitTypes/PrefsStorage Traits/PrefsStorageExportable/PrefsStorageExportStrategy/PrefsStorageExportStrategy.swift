//
//  PrefsStorageExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Export strategy used by prefs export formats.
public protocol PrefsStorageExportStrategy {
    /// The main method used to prepare local storage for export.
    func prepareForExport(storage: [String: Any]) throws -> [String: Any]
}
