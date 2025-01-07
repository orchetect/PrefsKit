//
//  PrefsStorageJSONImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables importing storage contents from a JSON file after initialization.
public protocol PrefsStorageJSONImportable where Self: PrefsStorage {
    /// Load the contents of a JSON file and replace storage or merge into existing storage.
    func load(json url: URL, by behavior: PrefsStorageImportBehavior) throws
    
    /// Load the contents of a JSON file and replace storage or merge into existing storage.
    func load(json data: Data, by behavior: PrefsStorageImportBehavior) throws
    
    /// Load the contents of a JSON file and replace storage or merge into existing storage.
    func load(json string: String, by behavior: PrefsStorageImportBehavior) throws
}
