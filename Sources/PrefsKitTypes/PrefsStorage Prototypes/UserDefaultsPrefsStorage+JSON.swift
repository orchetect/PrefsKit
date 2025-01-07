//
//  UserDefaultsPrefsStorage+JSON.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: PrefsStorageJSONExportable {
    public func exportJSONData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        try suite
            .dictionaryRepresentation()
            .jsonData(options: options)
    }
    
    public func exportJSONString(options: JSONSerialization.WritingOptions = []) throws -> String {
        try suite
            .dictionaryRepresentation()
            .jsonString(options: options)
    }
    
    public func exportJSON(to url: URL, options: JSONSerialization.WritingOptions = []) throws {
        try exportJSONData(options: options)
            .write(to: url)
    }
}

extension UserDefaultsPrefsStorage: PrefsStorageJSONImportable {
    public func load(json url: URL, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(json: url)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func load(json data: Data, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(json: data)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func load(json string: String, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(json: string)
        try load(unsafe: plistContent, by: behavior)
    }
}
