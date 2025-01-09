//
//  DictionaryPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: _PrefsStorageImportable {
    package func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageImportBehavior) throws {
        switch behavior {
        case .replacingStorage:
            storage = contents
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
        }
    }
    
    @_disfavoredOverload
    package func load(unsafe contents: [String: Any], by behavior: PrefsStorageImportBehavior) throws {
        switch behavior {
        case .replacingStorage:
            storage = contents
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
        }
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

extension DictionaryPrefsStorage: PrefsStoragePListImportable {
    public func load(plist url: URL, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: url)
        try self.load(unsafe: plistContent, by: behavior)
    }
    
    public func load(plist data: Data, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: data)
        try self.load(unsafe: plistContent, by: behavior)
    }
    
    public func load(plist dictionary: NSDictionary, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: dictionary)
        try self.load(unsafe: plistContent, by: behavior)
    }
}
