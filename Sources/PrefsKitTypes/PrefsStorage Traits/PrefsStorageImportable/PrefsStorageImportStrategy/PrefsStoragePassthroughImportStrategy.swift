//
//  PrefsStoragePassthroughImportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public struct PrefsStoragePassthroughImportStrategy {
    public init() { }
}

extension PrefsStoragePassthroughImportStrategy: PrefsStorageImportStrategy {
    public func prepareForImport(storage: [String : Any]) throws -> [String : Any] {
        // pass storage through as-is, no casting or conversions necessary
        storage
    }
}

// MARK: - Static Constructor

extension PrefsStorageImportStrategy where Self == PrefsStoragePassthroughImportStrategy {
    public static var passthrough: PrefsStoragePassthroughImportStrategy {
        PrefsStoragePassthroughImportStrategy()
    }
}
