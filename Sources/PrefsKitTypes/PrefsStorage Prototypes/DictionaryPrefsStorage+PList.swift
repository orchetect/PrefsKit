//
//  DictionaryPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStoragePListExportable {
    public func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try storage
            .plistData(format: format)
    }
    
    public func save(plist url: URL, format: PropertyListSerialization.PropertyListFormat = .xml) throws {
        try plistData(format: format)
            .write(to: url)
    }
}

// Note:
//
// `PrefsStoragePListInitializable` conformance is in class definition, as
// `open class` requires protocol-required inits to be defined there and not in an extension.
//

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
