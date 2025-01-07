//
//  PrefsStorageJSONPListExportableTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

@Suite(.serialized)
struct PrefsStorageJSONPListExportableTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    typealias StorageBackend = PrefsStorage & PrefsStoragePListExportable & PrefsStorageJSONExportable
    static let storageBackends: [any StorageBackend] = [
        .dictionary(unsafe: TestContent.Basic.Root.dictionary),
        .userDefaults(suite: UserDefaults(suiteName: domain)!) // content added in init()
    ]
    
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
    
    let keys = [Key1.key, Key2.key, Key3.key, Key4.key, Key5.key, Key6.key, Key7.key, Key8.key, Key9.key, Key10.key, Key11.key]
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        
        // load default contents
        let defaults = UserDefaults(suiteName: Self.domain)!
        defaults.merge(TestContent.Basic.Root.dictionary)
        
        // verify loaded default contents
        let defaultsKeys = defaults.dictionaryRepresentation().keys
        try #require(keys.allSatisfy { defaultsKeys.contains($0) })
    }
    
    // MARK: - JSON Tests
    
    @Test(arguments: Self.storageBackends)
    func exportJSONData(storage: any PrefsStorageJSONExportable) async throws {
        try await TestContent.Basic.checkContent(in: storage)
        let data = try storage.exportJSONData(options: [])
        
        let json = try JSONSerialization.jsonObject(with: data)
        var dict = try #require(json as? [String: Any])
        
        if dict.count > 11 {
            withKnownIssue("UserDefaults suite includes all search lists when requesting its `dictionaryRepresentation()`, which means a lot more keys than expected may be included.") {
                #expect(dict.count == 11)
                dict = dict.filter { keys.contains($0.key) }
            }
        }
        
        #expect(dict.count == 11)
        
        let newStorage = DictionaryPrefsStorage(unsafe: dict)
        try await TestContent.Basic.checkContent(in: newStorage)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test(arguments: Self.storageBackends)
    func exportJSON(storage: any PrefsStorageJSONExportable) async throws {
        try await TestContent.Basic.checkContent(in: storage)
        let url = URL.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).plist")
        try storage.exportJSON(to: url, options: [])
        let data = try Data(contentsOf: url)
        
        let json = try JSONSerialization.jsonObject(with: data)
        var dict = try #require(json as? [String: Any])
        
        if dict.count > 11 {
            withKnownIssue("UserDefaults suite includes all search lists when requesting its `dictionaryRepresentation()`, which means a lot more keys than expected may be included.") {
                #expect(dict.count == 11)
                dict = dict.filter { keys.contains($0.key) }
            }
        }
        
        #expect(dict.count == 11)
        
        let newStorage = DictionaryPrefsStorage(unsafe: dict)
        try await TestContent.Basic.checkContent(in: newStorage)
    }
    
    // MARK: - PList Tests
    
    @Test(arguments: Self.storageBackends)
    func exportPListData(storage: any PrefsStoragePListExportable) async throws {
        try await TestContent.Basic.checkContent(in: storage)
        let data = try storage.exportPListData(format: .xml)
        
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
        var dict = try #require(plist as? [String: Any])
        
        if dict.count > 11 {
            withKnownIssue("UserDefaults suite includes all search lists when requesting its `dictionaryRepresentation()`, which means a lot more keys than expected may be included.") {
                #expect(dict.count == 11)
                dict = dict.filter { keys.contains($0.key) }
            }
        }
        
        #expect(dict.count == 11)
        
        let newStorage = DictionaryPrefsStorage(unsafe: dict)
        try await TestContent.Basic.checkContent(in: newStorage)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @Test(arguments: Self.storageBackends)
    func exportPList(storage: any PrefsStoragePListExportable) async throws {
        try await TestContent.Basic.checkContent(in: storage)
        let url = URL.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).plist")
        try storage.exportPList(to: url, format: .xml)
        let data = try Data(contentsOf: url)
        
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
        var dict = try #require(plist as? [String: Any])
        
        if dict.count > 11 {
            withKnownIssue("UserDefaults suite includes all search lists when requesting its `dictionaryRepresentation()`, which means a lot more keys than expected may be included.") {
                #expect(dict.count == 11)
                dict = dict.filter { keys.contains($0.key) }
            }
        }
        
        #expect(dict.count == 11)
        
        let newStorage = DictionaryPrefsStorage(unsafe: dict)
        try await TestContent.Basic.checkContent(in: newStorage)
    }
}
