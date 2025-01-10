//
//  PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables loading storage contents.
///
/// > Note:
/// >
/// > Loading storage contents will not update local cache properties for any `@Pref` keys defined in a `@PrefsSchema`
/// > whose `storageMode` is set to `cachedReadStorageWrite`. The storage mode must be set to `storageOnly` to ensure
/// > data loads correctly.
public protocol PrefsStorageImportable where Self: PrefsStorage {
    /// Load key/values into storage.
    func load(from contents: [String: any PrefsStorageValue], by behavior: PrefsStorageUpdateStrategy) throws
    
    /// Load key/values into storage.
    func load(unsafe contents: [String: Any], by behavior: PrefsStorageUpdateStrategy) throws
    
    /// Import storage contents from a file on disk.
    func load<Format: PrefsStorageImportFormat>(
        from file: URL,
        format: Format,
        by behavior: PrefsStorageUpdateStrategy
    ) throws where Format: PrefsStorageImportFormatFileImportable
    
    /// Import storage contents from a format's raw data.
    func load<Format: PrefsStorageImportFormat>(
        from data: Data,
        format: Format,
        by behavior: PrefsStorageUpdateStrategy
    ) throws where Format: PrefsStorageImportFormatDataImportable
    
    /// Import storage contents from a format that supports string encoding/markup.
    func load<Format: PrefsStorageImportFormat>(
        from string: String,
        format: Format,
        by behavior: PrefsStorageUpdateStrategy
    ) throws where Format: PrefsStorageImportFormatStringImportable
}

// MARK: - Default Implementation

extension PrefsStorage where Self: PrefsStorageImportable {
    public func load<Format: PrefsStorageImportFormat>(
        from file: URL,
        format: Format,
        by behavior: PrefsStorageUpdateStrategy
    ) throws where Format: PrefsStorageImportFormatFileImportable {
        let loaded = try format.load(from: file)
        try load(unsafe: loaded, by: behavior)
    }
    
    public func load<Format: PrefsStorageImportFormat>(
        from data: Data,
        format: Format,
        by behavior: PrefsStorageUpdateStrategy
    ) throws where Format: PrefsStorageImportFormatDataImportable {
        let loaded = try format.load(from: data)
        try load(unsafe: loaded, by: behavior)
    }
    
    public func load<Format: PrefsStorageImportFormat>(
        from string: String,
        format: Format,
        by behavior: PrefsStorageUpdateStrategy
    ) throws where Format: PrefsStorageImportFormatStringImportable {
        let loaded = try format.load(from: string)
        try load(unsafe: loaded, by: behavior)
    }
}
