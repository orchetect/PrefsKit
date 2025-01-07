//
//  DictionaryPrefsStorage+JSON.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStorageJSONExportable {
    public func exportJSONData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        try storage
            .jsonData(options: options)
    }
    
    public func exportJSONString(options: JSONSerialization.WritingOptions = []) throws -> String {
        try storage
            .jsonString(options: options)
    }
    
    public func exportJSON(to url: URL, options: JSONSerialization.WritingOptions = []) throws {
        try exportJSONData(options: options)
            .write(to: url)
    }
}

// Note:
//
// `PrefsStorageJSONInitializable` conformance is in class definition, as
// `open class` requires protocol-required inits to be defined there and not in an extension.
//

extension PrefsStorage where Self == DictionaryPrefsStorage {
    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(json url: URL) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(json: url)
    }
    
    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(json data: Data) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(json: data)
    }
    
    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(json string: String) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(json: string)
    }
}

extension DictionaryPrefsStorage: PrefsStorageJSONImportable {
    public func load(json url: URL, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(json: url)
        try self.load(unsafe: plistContent, by: behavior)
    }
    
    public func load(json data: Data, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(json: data)
        try self.load(unsafe: plistContent, by: behavior)
    }
    
    public func load(json string: String, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(json: string)
        try self.load(unsafe: plistContent, by: behavior)
    }
}
