//
//  DictionaryPrefsStorage+PList.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - PList Interchange

extension DictionaryPrefsStorage {
    /// Replaces the local ``root`` dictionary with the contents of a plist file.
    public func load(plist url: URL) throws {
        root = try .init(plist: url)
    }
    
    /// Replaces the local ``root`` dictionary with the raw contents of a plist file.
    public func load(plist data: Data) throws {
        root = try .init(plist: data)
    }
    
    /// Saves the local ``root`` dictionary to a plist file.
    public func save(plist url: URL) throws {
        try root.plistData().write(to: url)
    }
    
    /// Returns the local ``root`` dictionary as raw plist file data.
    public func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try root.plistData(format: format)
    }
}

// MARK: - Utilities

extension [String: any PrefsStorageValue] {
    public init(plist url: URL) throws {
        let fileData = try Data(contentsOf: url)
        try self.init(plist: fileData)
    }
    
    public init(plist data: Data) throws {
        var fmt: PropertyListSerialization.PropertyListFormat = .xml // will be overwritten
        let dict = try PropertyListSerialization.propertyList(from: data, format: &fmt)
        guard let nsDict = dict as? NSDictionary else {
            throw CocoaError(.coderReadCorrupt)
        }
        let mappedDict = try convertToPrefDict(plist: nsDict)
        self = mappedDict
    }
    
    public func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try PropertyListSerialization.data(fromPropertyList: self, format: format, options: .init())
    }
}

func convertToPrefDict(plist nsDict: NSDictionary) throws -> [String: any PrefsStorageValue] {
    try nsDict.reduce(into: [:]) { base, pair in
        guard let key = pair.key as? String
        else { throw CocoaError(.coderReadCorrupt) }
        
        switch pair.value {
        case let v as String: base[key] = v
        case let v as Bool: base[key] = v
        case let v as Int: base[key] = v
        case let v as Double: base[key] = v
        case let v as Float: base[key] = v
        case let v as Data: base[key] = v
        case let v as NSArray: base[key] = AnyPrefsArray(try convertToPrefArray(plist: v))
        case let v as NSDictionary: base[key] = AnyPrefsDictionary(try convertToPrefDict(plist: v))
        default: throw CocoaError(.coderReadCorrupt)
        }
    }
}

func convertToPrefArray(plist nsArray: NSArray) throws -> [any PrefsStorageValue] {
    try nsArray.reduce(into: []) { base, element in
        switch element {
        case let v as String: base.append(v)
        case let v as Bool: base.append(v)
        case let v as Int: base.append(v)
        case let v as Double: base.append(v)
        case let v as Float: base.append(v)
        case let v as Data: base.append(v)
        case let v as NSArray: base.append(AnyPrefsArray(v as? [any PrefsStorageValue] ?? []))
        case let v as NSDictionary: base.append(AnyPrefsDictionary(try convertToPrefDict(plist: v)))
        default: throw CocoaError(.coderReadCorrupt)
        }
    }
}
