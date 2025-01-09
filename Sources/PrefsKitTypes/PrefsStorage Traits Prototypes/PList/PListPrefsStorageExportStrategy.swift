//
//  PListPrefsStorageExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public struct PListPrefsStorageExportStrategy {
    public init() { }
}

extension PListPrefsStorageExportStrategy: PrefsStorageDictionaryExportStrategy {
    public func prepareForExport(storage: [String: Any]) throws -> [String: Any] {
        // pass storage through as-is, no casting or conversions necessary
        storage
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportStrategy where Self == PListPrefsStorageExportStrategy {
    public static var plist: PListPrefsStorageExportStrategy {
        PListPrefsStorageExportStrategy()
    }
}
