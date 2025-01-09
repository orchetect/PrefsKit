//
//  AnyPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: _PrefsStorageImportable {
    package func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? _PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        try wrapped.load(raw: contents, by: behavior)
    }
    
    @_disfavoredOverload
    package func load(unsafe contents: [String: Any], by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? _PrefsStorageImportable else {
            throw PrefsStorageError.contentLoadingNotSupported
        }
        try wrapped.load(unsafe: contents, by: behavior)
    }
}

extension AnyPrefsStorage: PrefsStorageJSONImportable {
    public func load(json url: URL, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStorageJSONImportable else {
            throw PrefsStorageError.jsonLoadingNotSupported
        }
        try wrapped.load(json: url, by: behavior)
    }
    
    public func load(json data: Data, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStorageJSONImportable else {
            throw PrefsStorageError.jsonLoadingNotSupported
        }
        try wrapped.load(json: data, by: behavior)
    }
    
    public func load(json string: String, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStorageJSONImportable else {
            throw PrefsStorageError.jsonLoadingNotSupported
        }
        try wrapped.load(json: string, by: behavior)
    }
}

extension AnyPrefsStorage: PrefsStoragePListImportable {
    public func load(plist url: URL, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: url, by: behavior)
    }
    
    public func load(plist data: Data, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: data, by: behavior)
    }
    
    public func load(plist dictionary: NSDictionary, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: dictionary, by: behavior)
    }
}
