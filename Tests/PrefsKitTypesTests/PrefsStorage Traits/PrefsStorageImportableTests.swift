//
//  PrefsStorageImportableTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

@Suite(.serialized)
struct PrefsStorageImportableTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var base: [String: any PrefsStorageValue] {
        [
            "foo": "string",
            "bar": 123,
            "baz": 3.14 as Double
        ]
    }
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary(root: base)),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!)) // content added in init()
        ]
    }
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        
        // load default contents
        let defaults = UserDefaults(suiteName: Self.domain)!
        defaults.merge(Self.base)
        
        // verify loaded default contents
        try #require(defaults.string(forKey: "foo") == "string")
        try #require(defaults.integer(forKey: "bar") == 123)
        try #require(defaults.double(forKey: "baz") == 3.14)
        try #require(defaults.object(forKey: "boo") == nil)
    }
    
    // MARK: - Tests
    
    @Test(arguments: Self.storageBackends)
    func loadRawReplacing(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        try storage.load(raw: newContent, by: .replacingStorage)
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == Double?.none) // old key removed
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadRawMerging(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        try storage.load(raw: newContent, by: .mergingWithStorage)
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == 3.14 as Double) // key not contained in new content; old value
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadUnsafeReplacing(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        try storage.load(unsafe: newContent, by: .replacingStorage)
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == Double?.none) // old key removed
        #expect(storage.storageValue(forKey: "boo") == true)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadUnsafeMerging(storage: AnyPrefsStorage) async throws {
        let newContent: [String: any PrefsStorageValue] = [
            "foo": "new string", // key exists, new value of same type
            "bar": Data([0x01, 0x02]), // key exists, new value of different type incompatible with old type
            "boo": true // new key that doesn't exist
        ]
        
        try storage.load(unsafe: newContent, by: .mergingWithStorage)
        
        #expect(storage.storageValue(forKey: "foo") == "new string")
        #expect(storage.storageValue(forKey: "bar") == Data([0x01, 0x02]))
        #expect(storage.storageValue(forKey: "baz") == 3.14 as Double) // key not contained in new content; old value
        #expect(storage.storageValue(forKey: "boo") == true)
    }
}
