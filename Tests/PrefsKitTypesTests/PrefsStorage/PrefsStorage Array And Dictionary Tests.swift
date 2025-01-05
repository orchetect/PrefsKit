//
//  PrefsStorage Array And Dictionary Tests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitTypes
import Testing

@Suite struct PrefsStorageArrayTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!))
        ]
    }
    
    // MARK: - Atomic
    
    @Test(arguments: Self.storageBackends)
    func intArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [1, 2, 3])
        
        let key = AnyAtomicPrefsKey<[Int]>(key: "foo")
        
        let value: [Int] = try #require(storage.value(forKey: key))
        
        #expect(value == [1, 2, 3])
    }
    
    @Test(arguments: Self.storageBackends)
    func stringArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["a", "b", "c"])
        
        let key = AnyAtomicPrefsKey<[String]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == ["a", "b", "c"])
    }
    
    @Test(arguments: Self.storageBackends)
    func boolArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [true, false, true])
        
        let key = AnyAtomicPrefsKey<[Bool]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [true, false, true])
    }
    
    @Test(arguments: Self.storageBackends)
    func doubleArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [1.5, 2.5, 3.5] as [Double])
        
        let key = AnyAtomicPrefsKey<[Double]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func floatArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [1.5, 2.5, 3.5] as [Float])
        
        let key = AnyAtomicPrefsKey<[Float]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func dataArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [Data([0x01]), Data([0x02])])
        
        let key = AnyAtomicPrefsKey<[Data]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [Data([0x01]), Data([0x02])])
    }
    
    @Test(arguments: Self.storageBackends)
    func anyPrefsArrayArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: AnyPrefsArray([1, 2, "string", true]))
        
        let key = AnyAtomicPrefsKey<AnyPrefsArray>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [1, 2, "string", true])
    }
    
    // MARK: - Nested
    
    @Test(arguments: Self.storageBackends)
    func nestedStringArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [["a", "b"], ["c"]])
        
        let key = AnyAtomicPrefsKey<[[String]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [["a", "b"], ["c"]])
    }
    
    @Test(arguments: Self.storageBackends)
    func nestedAnyPrefsArrayArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: [["a", 2] as AnyPrefsArray, [true] as AnyPrefsArray])
        
        let key = AnyAtomicPrefsKey<[AnyPrefsArray]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == [["a", 2], [true]])
    }
}
 
@Suite struct PrefsStorageDictionaryTests {
    static let domain = "com.orchetect.PrefsKit.\(type(of: Self.self))"
    
    static var storageBackends: [AnyPrefsStorage] {
        [
            AnyPrefsStorage(.dictionary),
            AnyPrefsStorage(.userDefaults(suite: UserDefaults(suiteName: domain)!))
        ]
    }
    
    // MARK: - Atomic
    
    @Test(arguments: Self.storageBackends)
    func intArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1, 2, 3]])
        
        let key = AnyAtomicPrefsKey<[String: [Int]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1, 2, 3])
    }
    
    @Test(arguments: Self.storageBackends)
    func stringArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": ["a", "b", "c"]])
        
        let key = AnyAtomicPrefsKey<[String: [String]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == ["a", "b", "c"])
    }
    
    @Test(arguments: Self.storageBackends)
    func boolArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [true, false, true]])
        
        let key = AnyAtomicPrefsKey<[String: [Bool]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [true, false, true])
    }
    
    @Test(arguments: Self.storageBackends)
    func doubleArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1.5, 2.5, 3.5] as [Double]])
        
        let key = AnyAtomicPrefsKey<[String: [Double]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func floatArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [1.5, 2.5, 3.5] as [Float]])
        
        let key = AnyAtomicPrefsKey<[String: [Float]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [1.5, 2.5, 3.5])
    }
    
    @Test(arguments: Self.storageBackends)
    func dataArray(storage: AnyPrefsStorage) throws {
        storage.setStorageValue(forKey: "foo", to: ["bar": [Data([0x01]), Data([0x02])]])
        
        let key = AnyAtomicPrefsKey<[String: [Data]]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        let innerValue = try #require(value["bar"])
        
        #expect(innerValue == [Data([0x01]), Data([0x02])])
    }
    
    @Test(arguments: Self.storageBackends)
    func anyPrefsDictionaryArray(storage: AnyPrefsStorage) throws {
        let valueDict: AnyPrefsDictionary = ["one": 1, "two": 2, "string": "string", "bool": true]
        storage.setStorageValue(forKey: "foo", to: valueDict)
        
        let key = AnyAtomicPrefsKey<AnyPrefsDictionary>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == valueDict)
    }
    
    // MARK: - Nested
    
    @Test(arguments: Self.storageBackends)
    func nestedAnyPrefsDictionaryArray(storage: AnyPrefsStorage) throws {
        let valueDictInner: AnyPrefsDictionary = ["one": 1, "two": 2, "string": "string", "bool": true]
        let valueDictOuter = ["bar": valueDictInner]
        storage.setStorageValue(forKey: "foo", to: valueDictOuter)
        
        let key = AnyAtomicPrefsKey<[String: AnyPrefsDictionary]>(key: "foo")
        
        let value = try #require(storage.value(forKey: key))
        
        #expect(value == valueDictOuter)
    }
}
