//
//  PrefsStorageLoadable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Trait for ``PrefsStorage`` that enables loading storage contents.
///
/// This is package-level functionality and not available publicly.
/// 1. Meant for unit testing and debugging.
/// 2. Loading storage contents will not update local cache properties for any `@Pref` keys defined in a `@PrefsSchema`
///    whose `storageMode` is set to `cachedReadStorageWrite`. The storage mode must be set to `storageOnly` to ensure
///    data loads correctly.
package protocol _PrefsStorageLoadable where Self: PrefsStorage {
    /// Load key/values into storage.
    func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageLoadBehavior) throws
    
    /// Load key/values into storage.
    @_disfavoredOverload
    func load(raw contents: [String: Any], by behavior: PrefsStorageLoadBehavior) throws
}
