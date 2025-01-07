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
        
        #expect(storage.storageValue(forKey: Key1.key) == Key1.value)
        
        #expect(storage.storageValue(forKey: Key2.key) == Key2.value)
        
        #expect(storage.storageValue(forKey: Key3.key) == Key3.value)
        
        #expect(storage.storageValue(forKey: Key4.key) == Key4.value)
        
        // #expect(storage.storageValue(forKey: Key5.key) == Key5.value) // TODO: enable once Date conforms to PrefsStorageValue
        
        #expect(storage.storageValue(forKey: Key6.key) == Key6.value)
        
        let key7: [Any] = try #require(storage.storageValue(forKey: Key7.key))
        dump(key7)
        try #require(key7.count == 3)
        #expect(try #require(key7[0] as? String) == Key7.valueIndex0)
        #expect(try #require(key7[1] as? Int) == Key7.valueIndex1)
        #expect(try #require(key7[2] as? Bool) == Key7.valueIndex2)
        
        let key8: [Any] = try #require(storage.storageValue(forKey: Key8.key))
        try #require(key8.count == 2)
        // element 0
        let key8Element0 = try #require(key8[0] as? [String])
        try #require(key8Element0.count == 1)
        #expect(key8Element0[0] == Key8.valueIndex0Index0)
        // element 1
        let key8Element1 = try #require(key8[1] as? [String: Any])
        try #require(key8Element1.count == 2)
        #expect(key8Element1[Key8.KeyA.key] as? String == Key8.KeyA.value)
        #expect(key8Element1[Key8.KeyB.key] as? Int == Key8.KeyB.value)
        
        #expect(storage.storageValue(forKey: Key9.key) == Key9.value)
        
        let key10: [String: Any] = try #require(storage.storageValue(forKey: Key10.key))
        try #require(key10.count == 3)
        #expect(key10[Key10.KeyA.key] as? String == Key10.KeyA.value)
        #expect(key10[Key10.KeyB.key] as? Int == Key10.KeyB.value)
        #expect(key10[Key10.KeyC.key] as? Data == Key10.KeyC.value)
        
        let key11: [String: Any] = try #require(storage.storageValue(forKey: Key11.key))
        try #require(key11.count == 2)
        // key A
        let key11A = try #require(key11[Key11.KeyA.key] as? [String])
        #expect(key11A == Key11.KeyA.value)
        // key B
        let key11B = try #require(key11[Key11.KeyB.key] as? [String: Any])
        try #require(key11B.count == 2)
        #expect(key11B[Key11.KeyB.KeyI.key] as? String == Key11.KeyB.KeyI.value)
        #expect(key11B[Key11.KeyB.KeyII.key] as? Int == Key11.KeyB.KeyII.value)
    }
}
