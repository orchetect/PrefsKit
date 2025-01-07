//
//  PrefsStoragePListExportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables exporting storage contents in plist file format.
public protocol PrefsStoragePListExportable where Self: PrefsStorage {
    /// Returns the local storage contents as raw plist file data.
    func plistData(format: PropertyListSerialization.PropertyListFormat) throws -> Data
    
    /// Saves the local storage contents to a plist file.
    func save(plist url: URL, format: PropertyListSerialization.PropertyListFormat) throws
}
