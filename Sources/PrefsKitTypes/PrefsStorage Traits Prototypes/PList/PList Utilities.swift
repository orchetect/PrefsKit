//
//  PList Utilities.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Import

extension [String: Any] {
    package init(plist url: URL) throws {
        let fileData = try Data(contentsOf: url)
        try self.init(plist: fileData)
    }
    
    package init(plist data: Data) throws {
        var fmt: PropertyListSerialization.PropertyListFormat = .xml // will be overwritten
        let dict = try PropertyListSerialization.propertyList(from: data, format: &fmt)
        guard let nsDict = dict as? NSDictionary else {
            throw CocoaError(.coderReadCorrupt)
        }
        try self.init(plist: nsDict)
    }
    
    package init(plist dictionary: NSDictionary) throws {
        let mappedDict = try convertToPrefDict(plist: dictionary)
        self = mappedDict
    }
}

package func convertToPrefDict(plist nsDict: NSDictionary) throws -> [String: Any] {
    let dict: [String: Any] = try nsDict.reduce(into: [:]) { base, pair in
        guard let key = pair.key as? String
        else { throw CocoaError(.coderReadCorrupt) }
        
        switch pair.value {
        case let v as String: base[key] = v
        case let v as Bool: base[key] = v
        case let v as Int: base[key] = v
        case let v as Double: base[key] = v
        case let v as Float: base[key] = v
        case let v as Data: base[key] = v
        case let v as Date: base[key] = v
        case let v as NSArray: base[key] = try convertToPrefArray(plist: v)
        case let v as NSDictionary: base[key] = try convertToPrefDict(plist: v)
        default: throw CocoaError(.coderReadCorrupt)
        }
    }
    
    // return homogenous value type dictionary as-is, but type-erase mixed value type
    switch dict {
    case let v as [String: String]: return v
    case let v as [String: Bool]: return v
    case let v as [String: Int]: return v
    case let v as [String: Double]: return v
    case let v as [String: Float]: return v
    case let v as [String: Data]: return v
    case let v as [String: Date]: return v
    default: return dict
    }
}

package func convertToPrefArray(plist nsArray: NSArray) throws -> [Any] {
    let array: [Any] = try nsArray.reduce(into: []) { base, element in
        switch element {
        case let v as String: base.append(v)
        case let v as Bool: base.append(v)
        case let v as Int: base.append(v)
        case let v as Double: base.append(v)
        case let v as Float: base.append(v)
        case let v as Data: base.append(v)
        case let v as Date: base.append(v)
        case let v as NSArray: try base.append(convertToPrefArray(plist: v))
        case let v as NSDictionary: try base.append(convertToPrefDict(plist: v))
        default: throw CocoaError(.coderReadCorrupt)
        }
    }
    
    // return homogenous type arrays as-is, but type-erase mixed type arrays
    switch array {
    case let v as [String]: return v
    case let v as [Bool]: return v
    case let v as [Int]: return v
    case let v as [Double]: return v
    case let v as [Float]: return v
    case let v as [Data]: return v
    case let v as [Date]: return v
    default: return array
    }
}

// MARK: - Export

extension [String: Any] {
    package func plistData(format: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        try PropertyListSerialization
            .data(fromPropertyList: self, format: format, options: .init())
    }
    
    package func plistString(encoding: String.Encoding = .utf8) throws -> String {
        let data = try plistData(format: .xml)
        guard let string = String(data: data, encoding: encoding) else {
            throw PrefsStorageError.plistExportError
        }
        return string
    }
}
