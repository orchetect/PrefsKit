//
//  AnyPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: PrefsStoragePListExportable {
    public func plistData(format: PropertyListSerialization.PropertyListFormat) throws -> Data {
        guard let wrapped = wrapped as? PrefsStoragePListExportable else {
            throw PrefsStorageError.plistWritingNotSupported
        }
        return try wrapped.plistData(format: format)
    }
    
    public func save(plist url: URL, format: PropertyListSerialization.PropertyListFormat) throws {
        guard let wrapped = wrapped as? PrefsStoragePListExportable else {
            throw PrefsStorageError.plistWritingNotSupported
        }
        try wrapped.save(plist: url, format: format)
    }
}

extension AnyPrefsStorage: PrefsStoragePListImportable {
    public func `import`(plist url: URL, by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.import(plist: url, by: behavior)
    }
    
    public func `import`(plist data: Data, by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.import(plist: data, by: behavior)
    }
    
    public func `import`(plist dictionary: NSDictionary, by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.import(plist: dictionary, by: behavior)
    }
}
