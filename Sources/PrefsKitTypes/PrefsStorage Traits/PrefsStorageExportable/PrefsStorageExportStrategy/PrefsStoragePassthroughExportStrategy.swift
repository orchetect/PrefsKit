//
//  PrefsStoragePassthroughExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct PrefsStoragePassthroughExportStrategy {
    public init() { }
}

extension PrefsStoragePassthroughExportStrategy: PrefsStorageExportStrategy {
    public func prepareForExport(storage: [String: Any]) throws -> [String: Any] {
        // pass storage through as-is, no casting or conversions necessary
        storage
    }
}

// MARK: - Static Constructor

extension PrefsStorageExportStrategy where Self == PrefsStoragePassthroughExportStrategy {
    public static var passthrough: PrefsStoragePassthroughExportStrategy {
        PrefsStoragePassthroughExportStrategy()
    }
}
