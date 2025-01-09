//
//  PrefsStorageExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public protocol PrefsStorageExportStrategy {
    func prepareForExport(storage: [String: Any]) throws -> [String: Any]
}
