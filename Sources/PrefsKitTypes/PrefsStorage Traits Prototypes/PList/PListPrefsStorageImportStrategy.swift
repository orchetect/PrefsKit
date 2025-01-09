//
//  PListPrefsStorageImportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public typealias PListPrefsStorageImportStrategy = PrefsStoragePassthroughImportStrategy

// MARK: - Static Constructor

extension PrefsStorageImportStrategy where Self == PListPrefsStorageImportStrategy {
    public static var plist: PListPrefsStorageImportStrategy {
        PListPrefsStorageImportStrategy()
    }
}
