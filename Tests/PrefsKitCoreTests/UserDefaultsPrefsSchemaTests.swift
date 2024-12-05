//
//  UserDefaultsPrefsSchemaTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitCore
import Testing

@Suite(.serialized)
struct UserDefaultsPrefsSchemaTests {
    let testSuite: UserDefaults
    
    init() {
        let domain = "com.orchetect.PrefsKit.\(type(of: self))"
        UserDefaults.standard.removePersistentDomain(forName: domain)
        testSuite = UserDefaults(suiteName: domain)!
        
        schema = UserDefaultsSchema(storage: testSuite)
    }
    
    enum RawEnum: String, RawRepresentable {
        case one
        case two
    }
    
    // MARK: - Protocol Adoptions
    struct MockBasicPrefKey: BasicPrefKey {
        typealias Value = Bool
        let key: String = "foo"
    }
    
    struct MockBasicDefaultedPrefKey: BasicDefaultedPrefKey {
        typealias Value = Bool
        let key: String = "bar"
        let defaultValue: Value = true
    }
    
    struct MockRawRepresentablePrefKey: RawRepresentablePrefKey {
        typealias Value = RawEnum
        let key: String = "rawFoo"
    }
    
    struct MockDefaultedRawRepresentablePrefKey: DefaultedRawRepresentablePrefKey {
        typealias Value = RawEnum
        let key: String = "rawBar"
        let defaultValue: Value = .one
    }
    
    class UserDefaultsSchema: PrefsSchema {
        let storage: UserDefaults
        
        init(storage: UserDefaults) {
            self.storage = storage
        }
        
        lazy var basic = pref(MockBasicPrefKey())
        lazy var basicDefaulted = pref(MockBasicDefaultedPrefKey())
        lazy var rawRep = pref(MockRawRepresentablePrefKey())
        lazy var rawRepDefaulted = pref(MockDefaultedRawRepresentablePrefKey())
        
        lazy var int = pref(int: "int")
        lazy var string = pref(string: "string")
        lazy var bool = pref(bool: "bool")
        lazy var double = pref(double: "double")
        lazy var float = pref(float: "float")
        lazy var data = pref(data: "data")
        lazy var array = pref(array: "array")
        lazy var dict = pref(dictionary: "dict")
        
        lazy var intDefaulted = pref(int: "int", default: 1)
        lazy var stringDefaulted = pref(string: "string", default: "a string")
        lazy var boolDefaulted = pref(bool: "bool", default: true)
        lazy var doubleDefaulted = pref(double: "double", default: 1.5)
        lazy var floatDefaulted = pref(float: "float", default: 2.5)
        lazy var dataDefaulted = pref(data: "data", default: Data([0x01, 0x02]))
        lazy var arrayDefaulted = pref(array: "array", default: [123, "a string"])
        lazy var dictDefaulted = pref(dictionary: "dict", default: ["foo": 123, "bar": "a string"])
    }
    
    let schema: UserDefaultsSchema
    
    @Test func basicPrefKey() async throws {
        #expect(schema.basic.value == nil)
        
        schema.basic.value = false
        #expect(schema.basic.value == false)
        
        schema.basic.value = true
        #expect(schema.basic.value == true)
        
        schema.basic.value = nil
        #expect(schema.basic.value == nil)
    }
    
    @Test func basicDefaultedPrefKey() async throws {
        #expect(schema.basicDefaulted.value == true)
        
        schema.basicDefaulted.value = false
        #expect(schema.basicDefaulted.value == false)
        
        schema.basicDefaulted.value = true
        #expect(schema.basicDefaulted.value == true)
        
        // can't set nil
    }
    
    @Test func rawRepresentablePrefKey() async throws {
        #expect(schema.rawRep.value == nil)
        
        schema.rawRep.value = .one
        #expect(schema.rawRep.value == .one)
        
        schema.rawRep.value = .two
        #expect(schema.rawRep.value == .two)
        
        schema.rawRep.value = nil
        #expect(schema.rawRep.value == nil)
    }
    
    @Test func defaultedRawRepresentablePrefKey() async throws {
        #expect(schema.rawRepDefaulted.value == .one)
        
        schema.rawRepDefaulted.value = .one
        #expect(schema.rawRepDefaulted.value ==  .one)
        
        schema.rawRepDefaulted.value = .two
        #expect(schema.rawRepDefaulted.value == .two)
        
        // can't set nil
    }
    
    @Test func intPrefKey() async throws {
        #expect(schema.int.value == nil)
        
        schema.int.value = 1
        #expect(schema.int.value == 1)
        
        schema.int.value = 2
        #expect(schema.int.value == 2)
        
        schema.int.value = nil
        #expect(schema.int.value == nil)
    }
    
    @Test func stringPrefKey() async throws {
        #expect(schema.string.value == nil)
        
        schema.string.value = "1"
        #expect(schema.string.value == "1")
        
        schema.string.value = "2"
        #expect(schema.string.value == "2")
        
        schema.string.value = nil
        #expect(schema.string.value == nil)
    }
    
    @Test func boolPrefKey() async throws {
        #expect(schema.bool.value == nil)
        
        schema.bool.value = true
        #expect(schema.bool.value == true)
        
        schema.bool.value = false
        #expect(schema.bool.value == false)
        
        schema.bool.value = nil
        #expect(schema.bool.value == nil)
    }
    
    @Test func doublePrefKey() async throws {
        #expect(schema.double.value == nil)
        
        schema.double.value = 1.5
        #expect(schema.double.value == 1.5)
        
        schema.double.value = 2.0
        #expect(schema.double.value == 2.0)
        
        schema.double.value = nil
        #expect(schema.double.value == nil)
    }
    
    @Test func floatPrefKey() async throws {
        #expect(schema.float.value == nil)
        
        schema.float.value = 1.5
        #expect(schema.float.value == 1.5)
        
        schema.float.value = 2.0
        #expect(schema.float.value == 2.0)
        
        schema.float.value = nil
        #expect(schema.float.value == nil)
    }
    
    @Test func dataPrefKey() async throws {
        #expect(schema.data.value == nil)
        
        schema.data.value = Data([0x01, 0x02])
        #expect(schema.data.value == Data([0x01, 0x02]))
        
        schema.data.value = Data([0x03, 0x04])
        #expect(schema.data.value == Data([0x03, 0x04]))
        
        schema.data.value = nil
        #expect(schema.data.value == nil)
    }
    
    @Test func arrayPrefKey() async throws {
        #expect(schema.array.value == nil)
        
        schema.array.value = ["abc"]
        #expect(schema.array.value as? [String] == ["abc"])
        
        schema.array.value = [
            1 as Int,
            "xyz",
            true,
            150.0 as Double,
            200.5 as Float,
            Data([0x03, 0x04]),
            [456, "test"],
            ["def": 234, "ghi": 500.6]
        ]
        #expect(schema.array.value?.count == 8)
        #expect(schema.array.value?[0] as? Int == 1)
        #expect(schema.array.value?[1] as? String == "xyz")
        #expect(schema.array.value?[2] as? Bool == true)
        #expect(schema.array.value?[3] as? Double == 150.0)
        #expect(schema.array.value?[4] as? Float == 200.5)
        #expect(schema.array.value?[5] as? Data == Data([0x03, 0x04]))
        let arr = schema.array.value?[6] as? [any PrefStorageValue]
        #expect(arr?[0] as? Int == 456)
        #expect(arr?[1] as? String == "test")
        let dict = schema.array.value?[7] as? [String: any PrefStorageValue]
        #expect(dict?["def"] as? Int == 234)
        #expect(dict?["ghi"] as? Double == 500.6)
        
        schema.array.value = nil
        #expect(schema.array.value == nil)
    }
    
    @Test func dictionaryPrefKey() async throws {
        #expect(schema.dict.value == nil)
        
        schema.dict.value = ["abc": 123]
        #expect(schema.dict.value as? [String: Int] == ["abc": 123])
        
        schema.dict.value = [
            "a": 1 as Int,
            "b": "xyz",
            "c": true,
            "d": 150.0 as Double,
            "e": 200.5 as Float,
            "f": Data([0x03, 0x04]),
            "g": [456, "test"],
            "h": ["def": 234, "ghi": 500.6]
        ]
        #expect(schema.dict.value?.count == 8)
        #expect(schema.dict.value?["a"] as? Int == 1)
        #expect(schema.dict.value?["b"] as? String == "xyz")
        #expect(schema.dict.value?["c"] as? Bool == true)
        #expect(schema.dict.value?["d"] as? Double == 150.0)
        #expect(schema.dict.value?["e"] as? Float == 200.5)
        #expect(schema.dict.value?["f"] as? Data == Data([0x03, 0x04]))
        
        let arr = schema.dict.value?["g"] as? [any PrefStorageValue]
        #expect(arr?[0] as? Int == 456)
        #expect(arr?[1] as? String == "test")
        
        let dict = schema.dict.value?["h"] as? [String: any PrefStorageValue]
        #expect(dict?["def"] as? Int == 234)
        #expect(dict?["ghi"] as? Double == 500.6)
        
        schema.array.value = nil
        #expect(schema.array.value == nil)
    }
}
