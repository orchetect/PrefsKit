//
//  DictionaryPrefsStorage+PrefsStorageInitializable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Inits

// Note:
//
// `PrefsStorageInitializable` conformance is in class definition, as
// `open class` requires protocol-required inits to be defined there and not in an extension.
//

// MARK: - Static Constructors

// TODO: change these for methods using generics a la PrefsStorageImportable?

extension PrefsStorage where Self == DictionaryPrefsStorage {
    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(json url: URL) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(json: url)
    }
    
    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(json data: Data) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(json: data)
    }
    
    /// Dictionary prefs storage with initial root content from a JSON file.
    public static func dictionary(json string: String) throws -> DictionaryPrefsStorage {
        try DictionaryPrefsStorage(json: string)
    }
}

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
