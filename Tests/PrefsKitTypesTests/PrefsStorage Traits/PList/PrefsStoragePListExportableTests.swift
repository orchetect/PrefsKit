//
//  PrefsStoragePListExportableTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

@Suite(.serialized)
struct PrefsStoragePListExportableTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var storageBackends: [any PrefsStorage & PrefsStoragePListExportable] {
        [
            .dictionary(unsafe: TestPList.Basic.Root.dictionary),
            .userDefaults(suite: UserDefaults(suiteName: domain)!) // content added in init()
        ]
    }
    
    typealias Key1 = TestPList.Basic.Root.Key1
    typealias Key2 = TestPList.Basic.Root.Key2
    typealias Key3 = TestPList.Basic.Root.Key3
    typealias Key4 = TestPList.Basic.Root.Key4
    typealias Key5 = TestPList.Basic.Root.Key5
    typealias Key6 = TestPList.Basic.Root.Key6
    typealias Key7 = TestPList.Basic.Root.Key7
    typealias Key8 = TestPList.Basic.Root.Key8
    typealias Key9 = TestPList.Basic.Root.Key9
    typealias Key10 = TestPList.Basic.Root.Key10
    typealias Key11 = TestPList.Basic.Root.Key11
    
    let keys = [Key1.key, Key2.key, Key3.key, Key4.key, Key5.key, Key6.key, Key7.key, Key8.key, Key9.key, Key10.key, Key11.key]
    
    // MARK: - Init
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        
        // load default contents
        let defaults = UserDefaults(suiteName: Self.domain)!
        defaults.merge(TestPList.Basic.Root.dictionary)
        
        // verify loaded default contents
        let defaultsKeys = defaults.dictionaryRepresentation().keys
        try #require(keys.allSatisfy { defaultsKeys.contains($0) })
    }
    
    // MARK: - Tests
    
    @Test(arguments: Self.storageBackends)
    func exportPListData(storage: any PrefsStoragePListExportable) async throws {
        try await TestPList.Basic.checkContent(in: storage)
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
        try await TestPList.Basic.checkContent(in: newStorage)
    }
    
    @Test(arguments: Self.storageBackends)
    func exportPList(storage: any PrefsStoragePListExportable) async throws {
        try await TestPList.Basic.checkContent(in: storage)
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
        try await TestPList.Basic.checkContent(in: newStorage)
    }
}
