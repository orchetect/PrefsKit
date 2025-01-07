//
//  PrefsStoragePListLoadable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables loading storage contents from a plist file after initialization.
public protocol PrefsStoragePListLoadable where Self: PrefsStorage {
    /// Load the contents of a plist file and replace storage or merge into existing storage.
    func load(plist url: URL, by behavior: PrefsStorageLoadBehavior) throws
    
    /// Load the contents of a plist file and replace storage or merge into existing storage.
    func load(plist data: Data, by behavior: PrefsStorageLoadBehavior) throws
    
    /// Load the contents of a plist file and replace storage or merge into existing storage.
    func load(plist dictionary: NSDictionary, by behavior: PrefsStorageLoadBehavior) throws
}
