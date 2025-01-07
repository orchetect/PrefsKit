//
//  UserDefaultsPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: PrefsStoragePListExportable {
    public func exportPListData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try suite
            .dictionaryRepresentation()
            .plistData(format: format)
    }
    
    public func exportPList(to url: URL, format: PropertyListSerialization.PropertyListFormat = .xml) throws {
        try exportPListData(format: format)
            .write(to: url)
    }
}

extension UserDefaultsPrefsStorage: PrefsStoragePListImportable {
    public func load(plist url: URL, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: url)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func load(plist data: Data, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: data)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func load(plist dictionary: NSDictionary, by behavior: PrefsStorageImportBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: dictionary)
        try load(unsafe: plistContent, by: behavior)
    }
}
