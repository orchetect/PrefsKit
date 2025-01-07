//
//  PrefsStoragePListInitializableTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

@Suite(.serialized)
struct PrefsStoragePListInitializableTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var storageBackends: [any PrefsStoragePListInitializable.Type] {
        [
            DictionaryPrefsStorage.self
            // (`UserDefaultsPrefsStorage` does not conform to the protocol)
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
    
    // MARK: - Tests
    
    @Test(arguments: Self.storageBackends)
    func initPListData(storageType: any PrefsStoragePListInitializable.Type) async throws {
        let data = try #require(TestPList.Basic.xmlString.data(using: .utf8))
        let storage = try storageType.init(plist: data)
        
        try await TestPList.Basic.checkContent(in: storage)
    }
}
