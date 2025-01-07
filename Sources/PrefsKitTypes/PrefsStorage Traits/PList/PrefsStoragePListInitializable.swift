//
//  PrefsStoragePListInitializable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables initializing storage contents from a plist file.
public protocol PrefsStoragePListInitializable where Self: PrefsStorage {
    /// Initializes local storage with the contents of a plist file.
    init(plist url: URL) throws
    
    /// Initializes local storage with the contents of a plist file.
    init(plist data: Data) throws
    
    /// Initializes local storage with the contents of a plist file.
    init(plist dictionary: NSDictionary) throws
}
