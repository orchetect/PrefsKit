//
//  PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Trait for ``PrefsStorage`` that enables loading storage contents.
///
/// > Note:
/// >
/// > Loading storage contents will not update local cache properties for any `@Pref` keys defined in a `@PrefsSchema`
/// > whose `storageMode` is set to `cachedReadStorageWrite`. The storage mode must be set to `storageOnly` to ensure
/// > data loads correctly.
public protocol PrefsStorageImportable where Self: PrefsStorage {
    /// Load key/values into storage.
    func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageUpdateStrategy) throws
    
    /// Load key/values into storage.
    func load(unsafe contents: [String: Any], by behavior: PrefsStorageUpdateStrategy) throws
}
