//
//  PrefsStorageJSONExportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables exporting storage contents in JSON file format.
public protocol PrefsStorageJSONExportable where Self: PrefsStorage {
    /// Returns the local storage contents as raw JSON file data.
    func exportJSONData(options: JSONSerialization.WritingOptions) throws -> Data
    
    /// Returns the local storage contents as raw JSON file data.
    func exportJSONString(options: JSONSerialization.WritingOptions) throws -> String
    
    /// Saves the local storage contents to a JSON file.
    func exportJSON(to url: URL, options: JSONSerialization.WritingOptions) throws
}
