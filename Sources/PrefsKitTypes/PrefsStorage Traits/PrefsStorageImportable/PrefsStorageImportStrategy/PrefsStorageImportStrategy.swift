//
//  PrefsStorageImportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public protocol PrefsStorageImportStrategy {
    func prepareForImport(storage: [String: Any]) throws -> [String: Any]
}
