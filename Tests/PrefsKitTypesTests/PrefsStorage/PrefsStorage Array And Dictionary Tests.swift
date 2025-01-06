//
//  PrefsStorage Array And Dictionary Tests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

@Suite(.serialized)
struct PrefsStorageArrayTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!))
        ]
    }
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
    }
    
    // MARK: - Atomic
    
    @Test(arguments: Self.storageBackends)
    func intArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [1, 2, 3])
        
        let key = AnyAtomicPrefsKey<[Int]>(key: "foo")
        
        let value: [Int] = try #require(storage.value(forKey: key))
        
        #expect(value == [1, 2, 3])
    }
    
    @Test(arguments: Self.storageBackends)
    func stringArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["a", "b", "c"])
        
        let key = AnyAtomicPrefsKey<[String]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == ["a", "b", "c"])
    }
    
    @Test(arguments: Self.storageBackends)
    func boolArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [true, false, true])
        
        let key = AnyAtomicPrefsKey<[Bool]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [true, false, true])
    }
    
    @Test(arguments: Self.storageBackends)
    func doubleArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [1.5, 2.5, 3.5] as [Double])
        
        let key = AnyAtomicPrefsKey<[Double]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func floatArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [1.5, 2.5, 3.5] as [Float])
        
        let key = AnyAtomicPrefsKey<[Float]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func dataArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [Data([0x01]), Data([0x02])])
        
        let key = AnyAtomicPrefsKey<[Data]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [Data([0x01]), Data([0x02])])
    }
    
    @Test(arguments: Self.storageBackends)
    func anyPrefsArrayArray(storage: AnyPrefsStorage) async throws {
        let array: [Any] = [1, 2, "string", true]
        storage.setStorageValue(forKey: "foo", to: array)
        
        // TODO: test a new key type to accommodate `[Any]`?
        
        let value: [Any] = try #require(storage.storageValue(forKey: "foo"))
        try #require(value.count == 4)
        
        #expect(value[0] as? Int == 1)
        #expect(value[1] as? Int == 2)
        #expect(value[2] as? String == "string")
        #expect(value[3] as? Bool == true)
    }
    
    // MARK: - Nested
    
    @Test(arguments: Self.storageBackends)
    func nestedStringArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: [["a", "b"], ["c"]])
        
        let key = AnyAtomicPrefsKey<[[String]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [["a", "b"], ["c"]])
    }
    
    @Test(arguments: Self.storageBackends)
    func nestedAnyPrefsArrayArray(storage: AnyPrefsStorage) async throws {
        let array: [Any] = [["a", 2], [true]]
        storage.setStorageValue(forKey: "foo", to: array)
        
        // TODO: test a new key type to accommodate `[Any]`?
        
        let value: [Any] = try #require(storage.storageValue(forKey: "foo"))
        try #require(value.count == 2)
        
        let subArray1 = try #require(value[0] as? [Any])
        try #require(subArray1.count == 2)
        #expect(subArray1[0] as? String == "a")
        #expect(subArray1[1] as? Int == 2)
        
        let subArray2 = try #require(value[1] as? [Any])
        try #require(subArray2.count == 1)
        #expect(subArray2[0] as? Bool == true)
    }
}
 
@Suite(.serialized)
struct PrefsStorageDictionaryTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!))
        ]
    }
    
    init() async throws {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
    }
    
    // MARK: - Atomic
    
    @Test(arguments: Self.storageBackends)
    func intArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1, 2, 3]])
        
        let key = AnyAtomicPrefsKey<[String: [Int]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1, 2, 3])
    }
    
    @Test(arguments: Self.storageBackends)
    func stringArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": ["a", "b", "c"]])
        
        let key = AnyAtomicPrefsKey<[String: [String]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == ["a", "b", "c"])
    }
    
    @Test(arguments: Self.storageBackends)
    func boolArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [true, false, true]])
        
        let key = AnyAtomicPrefsKey<[String: [Bool]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [true, false, true])
    }
    
    @Test(arguments: Self.storageBackends)
    func doubleArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1.5, 2.5, 3.5] as [Double]])
        
        let key = AnyAtomicPrefsKey<[String: [Double]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func floatArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1.5, 2.5, 3.5] as [Float]])
        
        let key = AnyAtomicPrefsKey<[String: [Float]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func dataArray(storage: AnyPrefsStorage) async throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [Data([0x01]), Data([0x02])]])
        
        let key = AnyAtomicPrefsKey<[String: [Data]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [Data([0x01]), Data([0x02])])
    }
    
    @Test(arguments: Self.storageBackends)
    func anyPrefsDictionaryArray(storage: AnyPrefsStorage) async throws {
        let valueDict: [String: Any] = ["one": 1, "two": 2, "string": "string", "bool": true]
        storage.setStorageValue(forKey: "foo", to: valueDict)
        
        // TODO: test a new key type to accommodate `[String: Any]`?
        
        let value: [String: Any] = try #require(storage.storageValue(forKey: "foo"))
        
        try #require(value.count == 4)
        #expect(value["one"] as? Int == 1)
        #expect(value["two"] as? Int == 2)
        #expect(value["string"] as? String == "string")
        #expect(value["bool"] as? Bool == true)
    }
    
    // MARK: - Nested
    
    @Test(arguments: Self.storageBackends)
    func nestedAnyPrefsDictionaryArray(storage: AnyPrefsStorage) async throws {
        let valueDictInner: [String: Any] = ["one": 1, "two": 2, "string": "string", "bool": true]
        let valueDictOuter = ["bar": valueDictInner]
        storage.setStorageValue(forKey: "foo", to: valueDictOuter)
        
        // TODO: test a new key type to accommodate `[String: Any]`?
        
        let value: [String: Any] = try #require(storage.storageValue(forKey: "foo"))
        
        try #require(value.count == 1)
        let subValue = try #require(value["bar"] as? [String: Any])
        
        try #require(subValue.count == 4)
        #expect(subValue["one"] as? Int == 1)
        #expect(subValue["two"] as? Int == 2)
        #expect(subValue["string"] as? String == "string")
        #expect(subValue["bool"] as? Bool == true)
    }
}
