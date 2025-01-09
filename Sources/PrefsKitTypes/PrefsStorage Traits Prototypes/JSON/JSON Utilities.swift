//
//  JSON Utilities.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Import

extension [String: Any] {
    package init(json url: URL) throws {
        let fileData = try Data(contentsOf: url)
        try self.init(json: fileData)
    }
    
    package init(json data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        guard let dictionary = object as? [String: Any] else {
            throw PrefsStorageError.jsonFormatNotSupported
        }
        self = dictionary
    }
    
    package init(json string: String) throws {
        let data = try JSONSerialization.data(withJSONObject: string)
        try self.init(json: data)
    }
}

// MARK: - Export

extension [String: Any] {
    package func jsonData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        try JSONSerialization
            .data(withJSONObject: self, options: options)
    }
    
    package func jsonString(
        options: JSONSerialization.WritingOptions = [],
        encoding: String.Encoding = .utf8
    ) throws -> String {
        let data = try jsonData(options: options)
        guard let string = String(data: data, encoding: encoding) else {
            throw PrefsStorageError.jsonExportError
        }
        return string
    }
}