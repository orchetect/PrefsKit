//
//  PrefsStoragePListImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Trait for ``PrefsStorage`` that enables importing storage contents from a plist file after initialization.
public protocol PrefsStoragePListImportable where Self: PrefsStorage {
    /// Load the contents of a plist file and replace storage or merge into existing storage.
    func `import`(plist url: URL, by behavior: PrefsStorageLoadBehavior) throws
    
    /// Load the contents of a plist file and replace storage or merge into existing storage.
    func `import`(plist data: Data, by behavior: PrefsStorageLoadBehavior) throws
    
    /// Load the contents of a plist file and replace storage or merge into existing storage.
    func `import`(plist dictionary: NSDictionary, by behavior: PrefsStorageLoadBehavior) throws
}
