//
//  PrefsStorageImportableTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

/// Test PList and JSON import into prefs storage.
@Suite(.serialized)
struct PrefsStorageImportableTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var base: [String: any PrefsStorageValue] {
        [
            Key1.key: "old string",
            Key2.key: Data([0x08, 0x09]),
            "baseExclusive": 3.14 as Double
        ]
    }
    
    static var storageBackends: [any PrefsStorage & PrefsStorageImportable] {
        [
            .dictionary(root: base),
            .userDefaults(suite: UserDefaults(suiteName: domain)!) // content added in init()
        ]
    }
    
    typealias Key1 = TestContent.Basic.Root.Key1
    typealias Key2 = TestContent.Basic.Root.Key2
    typealias Key3 = TestContent.Basic.Root.Key3
    typealias Key4 = TestContent.Basic.Root.Key4
    typealias Key5 = TestContent.Basic.Root.Key5
    typealias Key6 = TestContent.Basic.Root.Key6
    typealias Key7 = TestContent.Basic.Root.Key7
    typealias Key8 = TestContent.Basic.Root.Key8
    typealias Key9 = TestContent.Basic.Root.Key9
    typealias Key10 = TestContent.Basic.Root.Key10
    typealias Key11 = TestContent.Basic.Root.Key11
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        
        // load default contents
        let defaults = UserDefaults(suiteName: Self.domain)!
        defaults.merge(Self.base)
        
        // verify loaded default contents
        try #require(defaults.string(forKey: Key1.key) == "old string")
        try #require(defaults.data(forKey: Key2.key) == Data([0x08, 0x09]))
        try #require(defaults.double(forKey: "baseExclusive") == 3.14)
        try #require(defaults.object(forKey: Key3.key) == nil)
        try #require(defaults.object(forKey: Key4.key) == nil)
        try #require(defaults.object(forKey: Key5.key) == nil)
        try #require(defaults.object(forKey: Key6.key) == nil)
        try #require(defaults.object(forKey: Key7.key) == nil)
        try #require(defaults.object(forKey: Key8.key) == nil)
        try #require(defaults.object(forKey: Key9.key) == nil)
        try #require(defaults.object(forKey: Key10.key) == nil)
        try #require(defaults.object(forKey: Key11.key) == nil)
    }
    
    // MARK: - JSON Tests
    
    @Test(arguments: Self.storageBackends)
    func loadJSONDataReplacing(storage: any PrefsStorage & PrefsStorageImportable) async throws {
        let data = try #require(TestContent.Basic.jsonString.data(using: .utf8))
        try storage.load(
            from: data,
            format: .json(strategy: TestContent.Basic.JSONPrefsStorageImportStrategy()),
            by: .replacingStorage
        )
        
        // check new content
        try await TestContent.Basic.checkContent(in: storage)
        
        // check old content was removed
        try #require(storage.storageValue(forKey: "baseExclusive") == Double?.none)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadJSONDataMerging(storage: any PrefsStorage & PrefsStorageImportable) async throws {
        let data = try #require(TestContent.Basic.jsonString.data(using: .utf8))
        try storage.load(
            from: data,
            format: .json(strategy: TestContent.Basic.JSONPrefsStorageImportStrategy()),
            by: .mergingWithStorage
        )
        
        // check new content
        try await TestContent.Basic.checkContent(in: storage)
        
        // check old content was removed
        try #require(storage.storageValue(forKey: "baseExclusive") == 3.14 as Double)
    }
    
    // MARK: - PList Tests
    
    @Test(arguments: Self.storageBackends)
    func loadPListDataReplacing(storage: any PrefsStorage & PrefsStorageImportable) async throws {
        let data = try #require(TestContent.Basic.plistString.data(using: .utf8))
        try storage.load(from: data, format: .plist(), by: .replacingStorage)
        
        // check new content
        try await TestContent.Basic.checkContent(in: storage)
        
        // check old content was removed
        try #require(storage.storageValue(forKey: "baseExclusive") == Double?.none)
    }
    
    @Test(arguments: Self.storageBackends)
    func loadPListDataMerging(storage: any PrefsStorage & PrefsStorageImportable) async throws {
        let data = try #require(TestContent.Basic.plistString.data(using: .utf8))
        try storage.load(from: data, format: .plist(), by: .mergingWithStorage)
        
        // check new content
        try await TestContent.Basic.checkContent(in: storage)
        
        // check old content was removed
        try #require(storage.storageValue(forKey: "baseExclusive") == 3.14 as Double)
    }
}
