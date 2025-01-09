//
//  PrefsStorageInitializable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageInitializable where Self: PrefsStorageImportable {
    init<Format: PrefsStorageImportFormat>(
        from url: URL,
        format: Format
    ) throws where Format: PrefsStorageImportFormatFileImportable
    
    init<Format: PrefsStorageImportFormat>(
        from data: Data,
        format: Format
    ) throws where Format: PrefsStorageImportFormatDataImportable
    
    init<Format: PrefsStorageImportFormat>(
        from string: String,
        format: Format
    ) throws where Format: PrefsStorageImportFormatStringImportable
}
