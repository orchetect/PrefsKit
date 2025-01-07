//
//  PrefsStorageLoadBehavior.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// Contents loading behavior for ``PrefsStorage`` load methods.
public enum PrefsStorageLoadBehavior {
    /// Replaces existing storage contents with new contents, removing all existing keys first.
    case replacingStorage
    
    /// Merges new content with existing storage contents.
    case mergingWithStorage
}
