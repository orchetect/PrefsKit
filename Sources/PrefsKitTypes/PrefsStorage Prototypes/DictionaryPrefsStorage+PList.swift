//
//  DictionaryPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStoragePListWritable {
    public func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try storage
            .plistData(format: format)
    }
    
    public func save(plist url: URL, format: PropertyListSerialization.PropertyListFormat = .xml) throws {
        try plistData(format: format)
            .write(to: url)
    }
}

extension DictionaryPrefsStorage: PrefsStoragePListInitializable {
    public convenience init(plist url: URL) throws {
        let plistContent: [String: Any] = try .init(plist: url)
        self.init(unsafe: plistContent)
    }
    
    public convenience init(plist data: Data) throws {
        let plistContent: [String: Any] = try .init(plist: data)
        self.init(unsafe: plistContent)
    }
    
    public convenience init(plist dictionary: NSDictionary) throws {
        let plistContent: [String: Any] = try .init(plist: dictionary)
        self.init(unsafe: plistContent)
    }
}

extension DictionaryPrefsStorage: PrefsStoragePListLoadable {
    public func load(plist url: URL, by behavior: PrefsStorageLoadBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: url)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func load(plist data: Data, by behavior: PrefsStorageLoadBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: data)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func load(plist dictionary: NSDictionary, by behavior: PrefsStorageLoadBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: dictionary)
        try load(unsafe: plistContent, by: behavior)
    }
}
