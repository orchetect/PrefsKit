//
//  AnyPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: _PrefsStorageImportable {
    package func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? _PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        try wrapped.load(raw: contents, by: behavior)
    }
    
    @_disfavoredOverload
    package func load(unsafe contents: [String: Any], by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? _PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        try wrapped.load(unsafe: contents, by: behavior)
    }
}
