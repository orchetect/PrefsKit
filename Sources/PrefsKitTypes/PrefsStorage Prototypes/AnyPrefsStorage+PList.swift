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

extension AnyPrefsStorage: PrefsStoragePListLoadable {
    public func load(plist url: URL, by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListLoadable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: url, by: behavior)
    }
    
    public func load(plist data: Data, by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListLoadable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: data, by: behavior)
    }
    
    public func load(plist dictionary: NSDictionary, by behavior: PrefsStorageLoadBehavior) throws {
        guard let wrapped = wrapped as? PrefsStoragePListLoadable else {
            throw PrefsStorageError.plistLoadingNotSupported
        }
        try wrapped.load(plist: dictionary, by: behavior)
    }
}
