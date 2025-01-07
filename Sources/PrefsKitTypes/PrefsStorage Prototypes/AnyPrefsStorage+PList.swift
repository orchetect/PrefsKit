//
//  AnyPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension AnyPrefsStorage: PrefsStoragePListExportable {
    public func exportPListData(format: PropertyListSerialization.PropertyListFormat) throws -> Data {
        guard let wrapped = wrapped as? PrefsStoragePListExportable else {
            throw PrefsStorageError.plistWritingNotSupported
        }
        return try wrapped.exportPListData(format: format)
    }
    
    public func exportPList(to url: URL, format: PropertyListSerialization.PropertyListFormat) throws {
        guard let wrapped = wrapped as? PrefsStoragePListExportable else {
            throw PrefsStorageError.plistWritingNotSupported
        }
        try wrapped.exportPList(to: url, format: format)
    }
}

extension AnyPrefsStorage: PrefsStoragePListImportable {
    public func load(plist url: URL, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: url, by: behavior)
    }
    
    public func load(plist data: Data, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: data, by: behavior)
    }
    
    public func load(plist dictionary: NSDictionary, by behavior: PrefsStorageImportBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListImportable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: dictionary, by: behavior)
    }
}
