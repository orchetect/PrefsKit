//
//  PrefsStorageJSONInitializable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables initializing storage contents from a JSON file.
public protocol PrefsStorageJSONInitializable where Self: PrefsStorage {
    /// Initializes local storage with the contents of a JSON file.
    init(json url: URL) throws
    
    /// Initializes local storage with the contents of a JSON file.
    init(json data: Data) throws
    
    /// Initializes local storage with the contents of a JSON file.
    init(json string: String) throws
}
