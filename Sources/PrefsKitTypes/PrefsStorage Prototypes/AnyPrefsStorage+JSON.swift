//
//  AnyPrefsStorage+JSON.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: PrefsStorageJSONExportable {
    public func exportJSONData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        guard let wrapped = wrapped as? PrefsStorageJSONExportable else {
            throw PrefsStorageError.jsonWritingNotSupported
        }
        return try wrapped.exportJSONData(options: options)
    }
    
    public func exportJSONString(options: JSONSerialization.WritingOptions = []) throws -> String {
        guard let wrapped = wrapped as? PrefsStorageJSONExportable else {
            throw PrefsStorageError.jsonWritingNotSupported
        }
        return try wrapped.exportJSONString(options: options)
    }
    
    public func exportJSON(to url: URL, options: JSONSerialization.WritingOptions = []) throws {
        guard let wrapped = wrapped as? PrefsStorageJSONExportable else {
            throw PrefsStorageError.jsonWritingNotSupported
        }
        try wrapped.exportJSON(to: url, options: options)
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
