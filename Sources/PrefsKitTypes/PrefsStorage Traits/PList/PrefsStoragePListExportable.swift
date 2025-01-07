//
//  PrefsStoragePListExportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables exporting storage contents in plist file format.
public protocol PrefsStoragePListExportable where Self: PrefsStorage {
    /// Returns the local storage contents as raw plist file data.
    func exportPListData(format: PropertyListSerialization.PropertyListFormat) throws -> Data
    
    /// Saves the local storage contents to a plist file.
    func exportPList(to url: URL, format: PropertyListSerialization.PropertyListFormat) throws
}
