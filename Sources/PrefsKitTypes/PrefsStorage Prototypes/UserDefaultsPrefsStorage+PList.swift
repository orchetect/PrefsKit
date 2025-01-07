//
//  UserDefaultsPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: PrefsStoragePListExportable {
    public func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try suite
            .dictionaryRepresentation()
            .plistData(format: format)
    }
    
    public func save(plist url: URL, format: PropertyListSerialization.PropertyListFormat = .xml) throws {
        try plistData(format: format)
            .write(to: url)
    }
}

extension UserDefaultsPrefsStorage: PrefsStoragePListImportable {
    public func `import`(plist url: URL, by behavior: PrefsStorageLoadBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: url)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func `import`(plist data: Data, by behavior: PrefsStorageLoadBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: data)
        try load(unsafe: plistContent, by: behavior)
    }
    
    public func `import`(plist dictionary: NSDictionary, by behavior: PrefsStorageLoadBehavior) throws {
        let plistContent: [String: Any] = try .init(plist: dictionary)
        try load(unsafe: plistContent, by: behavior)
    }
}