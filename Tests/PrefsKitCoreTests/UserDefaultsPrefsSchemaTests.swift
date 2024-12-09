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
    static let domain = { "com.orchetect.PrefsKit.\(type(of: Self.self))" }()
    
    static func testSuite() -> UserDefaults {
        UserDefaults(suiteName: domain)!
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    init() {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
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
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    final class TestSchema: PrefsSchema, @unchecked Sendable {
        let storage: any PrefsStorage
        
        init(storage: any PrefsStorage) {
            self.storage = storage
        }
        
        enum Key {
            static let rawFoo = "rawFoo"
            static let rawBar = "rawBar"
            
            static let int = "int"
            static let string = "string"
            static let bool = "bool"
            static let double = "double"
            static let float = "float"
            static let data = "data"
            static let anyArray = "anyArray"
            static let stringArray = "stringArray"
            static let anyDict = "anyDict"
        }
        
        lazy var basic = pref(MockBasicPrefKey())
        lazy var basicDefaulted = pref(MockBasicDefaultedPrefKey())
        
        lazy var rawRep = pref(MockRawRepresentablePrefKey())
        lazy var rawRepDefaulted = pref(MockDefaultedRawRepresentablePrefKey())
        
        lazy var rawRep2 = pref(Key.rawFoo, of: RawEnum.self)
        lazy var rawRepDefaulted2 = pref(Key.rawBar, of: RawEnum.self, default: .one)
        
        lazy var int = pref(int: Key.int)
        lazy var string = pref(string: Key.string)
        lazy var bool = pref(bool: Key.bool)
        lazy var double = pref(double: Key.double)
        lazy var float = pref(float: Key.float)
        lazy var data = pref(data: Key.data)
        lazy var anyArray = pref(array: Key.anyArray)
        lazy var stringArray = pref(array: Key.anyArray, of: String.self)
        lazy var anyDict = pref(dictionary: Key.anyDict)
        lazy var stringDict = pref(dictionary: Key.anyDict, of: String.self)
        
        lazy var intDefaulted = pref(int: Key.int, default: 1)
        lazy var stringDefaulted = pref(string: Key.string, default: "a string")
        lazy var boolDefaulted = pref(bool: Key.bool, default: true)
        lazy var doubleDefaulted = pref(double: Key.double, default: 1.5)
        lazy var floatDefaulted = pref(float: Key.float, default: 2.5)
        lazy var dataDefaulted = pref(data: Key.data, default: Data([0x01, 0x02]))
        lazy var anyArrayDefaulted = pref(array: Key.anyArray, default: [123, "a string"])
        lazy var stringArrayDefaulted = pref(array: Key.stringArray, of: String.self, default: ["a", "b"])
        lazy var anyDictDefaulted = pref(dictionary: Key.anyDict, default: ["foo": 123, "bar": "a string"])
        lazy var stringDictDefaulted = pref(dictionary: Key.anyDict, of: String.self, default: ["a": "123", "b": "456"])
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    static var schemas: [TestSchema] {
        [
            TestSchema(storage: UserDefaultsPrefsStorage(suite: testSuite())),
            TestSchema(storage: DictionaryPrefsStorage())
        ]
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas)
    func basicPrefKey(schema: TestSchema) async throws {
        #expect(schema.basic.value == nil)
        
        schema.basic.value = false
        #expect(schema.basic.value == false)
        
        schema.basic.value = true
        #expect(schema.basic.value == true)
        
        schema.basic.value?.toggle()
        #expect(schema.basic.value == false)
        
        schema.basic.value = nil
        #expect(schema.basic.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func basicDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.basicDefaulted.value == true)
        
        schema.basicDefaulted.value = false
        #expect(schema.basicDefaulted.value == false)
        
        schema.basicDefaulted.value.toggle()
        #expect(schema.basicDefaulted.value == true)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func rawRepresentablePrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRep.value == nil)
        
        schema.rawRep.value = .one
        #expect(schema.rawRep.value == .one)
        
        schema.rawRep.value = .two
        #expect(schema.rawRep.value == .two)
        
        schema.rawRep.value = nil
        #expect(schema.rawRep.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func defaultedRawRepresentablePrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRepDefaulted.value == .one)
        
        schema.rawRepDefaulted.value = .one
        #expect(schema.rawRepDefaulted.value ==  .one)
        
        schema.rawRepDefaulted.value = .two
        #expect(schema.rawRepDefaulted.value == .two)
        
        // can't set nil
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func rawRepresentable2PrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRep2.value == nil)
        
        schema.rawRep2.value = .one
        #expect(schema.rawRep2.value == .one)
        
        schema.rawRep2.value = .two
        #expect(schema.rawRep2.value == .two)
        
        schema.rawRep2.value = nil
        #expect(schema.rawRep2.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func defaultedRawRepresentable2PrefKey(schema: TestSchema) async throws {
        #expect(schema.rawRepDefaulted2.value == .one)
        
        schema.rawRepDefaulted2.value = .one
        #expect(schema.rawRepDefaulted2.value ==  .one)
        
        schema.rawRepDefaulted2.value = .two
        #expect(schema.rawRepDefaulted2.value == .two)
        
        // can't set nil
    }
    
    // MARK: - Non-Defaulted (Basic)
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func intPrefKey(schema: TestSchema) async throws {
        #expect(schema.int.value == nil)
        
        schema.int.value = 1
        #expect(schema.int.value == 1)
        
        schema.int.value = 2
        #expect(schema.int.value == 2)
        
        schema.int.value? += 1
        #expect(schema.int.value == 3)
        
        schema.int.value = nil
        #expect(schema.int.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func stringPrefKey(schema: TestSchema) async throws {
        #expect(schema.string.value == nil)
        
        schema.string.value = "1"
        #expect(schema.string.value == "1")
        
        schema.string.value = "2"
        #expect(schema.string.value == "2")
        
        schema.string.value? += "0"
        #expect(schema.string.value == "20")
        
        schema.string.value = nil
        #expect(schema.string.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func boolPrefKey(schema: TestSchema) async throws {
        #expect(schema.bool.value == nil)
        
        schema.bool.value = true
        #expect(schema.bool.value == true)
        
        schema.bool.value = false
        #expect(schema.bool.value == false)
        
        schema.bool.value?.toggle()
        #expect(schema.bool.value == true)
        
        schema.bool.value = nil
        #expect(schema.bool.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func doublePrefKey(schema: TestSchema) async throws {
        #expect(schema.double.value == nil)
        
        schema.double.value = 1.5
        #expect(schema.double.value == 1.5)
        
        schema.double.value = 2.0
        #expect(schema.double.value == 2.0)
        
        schema.double.value? += 1.0
        #expect(schema.double.value == 3.0)
        
        schema.double.value = nil
        #expect(schema.double.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func floatPrefKey(schema: TestSchema) async throws {
        #expect(schema.float.value == nil)
        
        schema.float.value = 1.5
        #expect(schema.float.value == 1.5)
        
        schema.float.value = 2.0
        #expect(schema.float.value == 2.0)
        
        schema.float.value? += 1.0
        #expect(schema.float.value == 3.0)
        
        schema.float.value = nil
        #expect(schema.float.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func dataPrefKey(schema: TestSchema) async throws {
        #expect(schema.data.value == nil)
        
        schema.data.value = Data([0x01, 0x02])
        #expect(schema.data.value == Data([0x01, 0x02]))
        
        schema.data.value = Data([0x03, 0x04])
        #expect(schema.data.value == Data([0x03, 0x04]))
        
        schema.data.value?.append(contentsOf: [0x05])
        #expect(schema.data.value == Data([0x03, 0x04, 0x05]))
        
        schema.data.value = nil
        #expect(schema.data.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func anyArrayPrefKey(schema: TestSchema) async throws {
        #expect(schema.anyArray.value == nil)
        
        schema.anyArray.value = ["abc"]
        #expect(schema.anyArray.value?.count == 1)
        #expect(schema.anyArray.value?[0] as? String == "abc")
        
        schema.anyArray.value?.append("xyz")
        #expect(schema.anyArray.value?.count == 2)
        #expect(schema.anyArray.value?[0] as? String == "abc")
        #expect(schema.anyArray.value?[1] as? String == "xyz")
        
        schema.anyArray.value = [
            1 as Int,
            "xyz",
            true,
            150.0 as Double,
            200.5 as Float,
            Data([0x03, 0x04]),
            [456, "test"] as AnyPrefArray,
            ["def": 234, "ghi": "str"] as AnyPrefDictionary
        ]
        #expect(schema.anyArray.value?.count == 8)
        #expect(schema.anyArray.value?[0] as? Int == 1)
        #expect(schema.anyArray.value?[1] as? String == "xyz")
        #expect(schema.anyArray.value?[2] as? Bool == true)
        #expect(schema.anyArray.value?[3] as? Double == 150.0)
        #expect(schema.anyArray.value?[4] as? Float == 200.5)
        #expect(schema.anyArray.value?[5] as? Data == Data([0x03, 0x04]))
        let arr = schema.anyArray.value?[6] as? AnyPrefArray
        #expect(arr?[0] as? Int == 456)
        #expect(arr?[1] as? String == "test")
        let dict = schema.anyArray.value?[7] as? AnyPrefDictionary
        #expect(dict?["def"] as? Int == 234)
        #expect(dict?["ghi"] as? String == "str")
        
        schema.anyArray.value = nil
        #expect(schema.anyArray.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func typedArrayPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringArray.value == nil)
        
        schema.stringArray.value = ["abc"]
        #expect(schema.stringArray.value?.count == 1)
        #expect(schema.stringArray.value?[0] == "abc")
        
        schema.stringArray.value?[0] = "foo"
        #expect(schema.stringArray.value?.count == 1)
        #expect(schema.stringArray.value?[0] == "foo")
        
        schema.stringArray.value = ["def", "xyz"]
        #expect(schema.stringArray.value?.count == 2)
        #expect(schema.stringArray.value?[0] == "def")
        #expect(schema.stringArray.value?[1] == "xyz")
        
        schema.anyArray.value = nil
        #expect(schema.anyArray.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func anyDictionaryPrefKey(schema: TestSchema) async throws {
        #expect(schema.anyDict.value == nil)
        
        schema.anyDict.value = ["abc": 123]
        #expect(schema.anyDict.value?.count == 1)
        #expect(schema.anyDict.value?["abc"] as? Int == 123)
        
        schema.anyDict.value = [
            "a": 1 as Int,
            "b": "xyz",
            "c": true,
            "d": 150.0 as Double,
            "e": 200.5 as Float,
            "f": Data([0x03, 0x04]),
            "g": [456, "test"] as AnyPrefArray,
            "h": ["def": 234, "ghi": 500.6] as AnyPrefDictionary
        ]
        #expect(schema.anyDict.value?.count == 8)
        #expect(schema.anyDict.value?["a"] as? Int == 1)
        #expect(schema.anyDict.value?["b"] as? String == "xyz")
        #expect(schema.anyDict.value?["c"] as? Bool == true)
        #expect(schema.anyDict.value?["d"] as? Double == 150.0)
        #expect(schema.anyDict.value?["e"] as? Float == 200.5)
        #expect(schema.anyDict.value?["f"] as? Data == Data([0x03, 0x04]))
        
        let arr = schema.anyDict.value?["g"] as? AnyPrefArray
        #expect(arr?[0] as? Int == 456)
        #expect(arr?[1] as? String == "test")
        
        let dict = schema.anyDict.value?["h"] as? AnyPrefDictionary
        #expect(dict?["def"] as? Int == 234)
        #expect(dict?["ghi"] as? Double == 500.6)
        
        schema.anyDict.value = nil
        #expect(schema.anyDict.value == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func typedDictionaryPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringDict.value == nil)
        
        schema.stringDict.value = ["a": "abc"]
        #expect(schema.stringDict.value?.count == 1)
        #expect(schema.stringDict.value?["a"] == "abc")
        
        schema.stringDict.value?["a"] = "def"
        #expect(schema.stringDict.value?.count == 1)
        #expect(schema.stringDict.value?["a"] == "def")
        
        schema.stringDict.value = nil
        #expect(schema.stringDict.value == nil)
    }
    
    // MARK: - Defaulted (Basic)
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func intDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.intDefaulted.value == 1)
        
        schema.intDefaulted.value = 2
        #expect(schema.intDefaulted.value == 2)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func stringDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringDefaulted.value == "a string")
        
        schema.stringDefaulted.value = "1"
        #expect(schema.stringDefaulted.value == "1")
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func boolDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.boolDefaulted.value == true)
        
        schema.boolDefaulted.value = false
        #expect(schema.boolDefaulted.value == false)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func doubleDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.doubleDefaulted.value == 1.5)
        
        schema.doubleDefaulted.value = 3.25
        #expect(schema.doubleDefaulted.value == 3.25)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func floatDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.floatDefaulted.value == 2.5)
        
        schema.floatDefaulted.value = 5.6
        #expect(schema.floatDefaulted.value == 5.6)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func dataDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.dataDefaulted.value == Data([0x01, 0x02]))
        
        schema.dataDefaulted.value = Data([0x03, 0x04])
        #expect(schema.dataDefaulted.value == Data([0x03, 0x04]))
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func anyArrayDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.anyArrayDefaulted.value.count == 2)
        #expect(schema.anyArrayDefaulted.value[0] as? Int == 123)
        #expect(schema.anyArrayDefaulted.value[1] as? String == "a string")
        
        schema.anyArrayDefaulted.value = ["abc"]
        #expect(schema.anyArrayDefaulted.value.count == 1)
        #expect(schema.anyArrayDefaulted.value[0] as? String == "abc")
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func stringArrayDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringArrayDefaulted.value.count == 2)
        #expect(schema.stringArrayDefaulted.value == ["a", "b"])
        
        schema.stringArrayDefaulted.value = ["abc"]
        #expect(schema.stringArrayDefaulted.value.count == 1)
        #expect(schema.stringArrayDefaulted.value == ["abc"])
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func anyDictionaryDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.anyDictDefaulted.value.count == 2)
        #expect(schema.anyDictDefaulted.value["foo"] as? Int == 123)
        #expect(schema.anyDictDefaulted.value["bar"] as? String == "a string")
        
        schema.anyDictDefaulted.value = ["abc": 456]
        #expect(schema.anyDictDefaulted.value.count == 1)
        #expect(schema.anyDictDefaulted.value["abc"] as? Int == 456)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test(arguments: schemas) func stringDictionaryDefaultedPrefKey(schema: TestSchema) async throws {
        #expect(schema.stringDictDefaulted.value.count == 2)
        #expect(schema.stringDictDefaulted.value["a"] == "123")
        #expect(schema.stringDictDefaulted.value["b"] == "456")
        
        schema.stringDictDefaulted.value = ["c": "789"]
        #expect(schema.stringDictDefaulted.value.count == 1)
        #expect(schema.stringDictDefaulted.value["c"] == "789")
    }
}
