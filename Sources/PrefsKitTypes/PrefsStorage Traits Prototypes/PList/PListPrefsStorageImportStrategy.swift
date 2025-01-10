//
//  PListPrefsStorageImportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Prefs storage import strategy to import storage as plist (property list).
public typealias PListPrefsStorageImportStrategy = PrefsStoragePassthroughImportStrategy

// MARK: - Static Constructor

extension PrefsStorageImportStrategy where Self == PListPrefsStorageImportStrategy {
    /// Prefs storage import strategy to import storage as plist (property list).
    public static var plist: PListPrefsStorageImportStrategy {
        PListPrefsStorageImportStrategy()
    }
}
