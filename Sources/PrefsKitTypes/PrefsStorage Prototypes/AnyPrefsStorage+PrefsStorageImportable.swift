//
//  AnyPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: PrefsStorageImportable {
    public func load(from contents: [String: any PrefsStorageValue], by behavior: PrefsStorageUpdateStrategy) throws {
        guard let wrapped = wrapped as? PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        try wrapped.load(from: contents, by: behavior)
    }
    
    public func load(unsafe contents: [String: Any], by behavior: PrefsStorageUpdateStrategy) throws {
        guard let wrapped = wrapped as? PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        try wrapped.load(unsafe: contents, by: behavior)
    }
}
