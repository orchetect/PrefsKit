//
//  PrefsSchemaMode.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// Pref property access storage mode for ``PrefsSchema`` implementations.
public enum PrefsSchemaMode {
    /// Directly read and write from prefs schema `storage` on every access to pref properties without cacheing.
    /// This may have performance impacts on frequent accesses or for data types with expensive decoding operations.
    case storageOnly
    
    /// Reads property values from storage on initialization, but caches subsequent writes locally in addition to
    /// writing them to storage for improved read performance thereafter.
    ///
    /// This mode is recommended for improved performance.
    ///
    /// > Note:
    /// > This mode is suitable for storage that cannot or will not change externally. Changes made externally
    /// > will not be reflected within the schema and will be overwritten with cached values.
    case cachedReadStorageWrite
    
    // TODO: could implement this feature in future if there is a way to enumerate all prefs in a PrefsSchema
    // /// Reads property values from storage on initialization, then operates exclusively from cache for reads and
    // /// writes.
    // ///
    // /// Writes are not automatically written to storage. Changes to pref values must be manually committed by calling
    // /// `commit()` on the prefs schema which writes all cached pref values to storage. It is recommended to do this
    // /// only periodically or upon context switches (such as when the user invokes a Save Settings command, or your
    // /// application quits).
    // ///
    // /// > Note:
    // /// > This mode is suitable for storage that cannot or will not change externally. Changes made externally
    // /// > will not be reflected within the schema and will be overwritten with cached values.
    // case cacheOnly
}

extension PrefsSchemaMode: Equatable { }

extension PrefsSchemaMode: Hashable { }

extension PrefsSchemaMode: Sendable { }
