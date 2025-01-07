//
//  DictionaryPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStoragePListExportable {
    public func exportPListData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try storage
            .plistData(format: format)
    }
    
    public func exportPList(to url: URL, format: PropertyListSerialization.PropertyListFormat = .xml) throws {
        try exportPListData(format: format)
            .write(to: url)
    }
}

// Note:
//
// `PrefsStoragePListInitializable` conformance is in class definition, as
// `open class` requires protocol-required inits to be defined there and not in an extension.
//

extension PrefsStorage where Self == DictionaryPrefsStorage {
    /// Dictionary prefs storage with initial root content from a plist file.
    public static func dictionary(plist url: URL) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(plist: url)
    }
    
    /// Dictionary prefs storage with initial root content from a plist file.
    public static func dictionary(plist data: Data) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(plist: data)
    }
    
    /// Dictionary prefs storage with initial root content from a plist file.
    public static func dictionary(plist dictionary: NSDictionary) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(plist: dictionary)
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
