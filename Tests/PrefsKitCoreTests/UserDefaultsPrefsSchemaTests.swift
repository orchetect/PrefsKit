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
    struct Foo: BasicPrefKey {
        typealias Value = Bool
        let key: String = "foo"
    }
    
    struct Bar: BasicDefaultedPrefKey {
        typealias Value = Bool
        let key: String = "bar"
        let defaultValue: Value = true
    }
    
    struct RawFoo: RawRepresentablePrefKey {
        typealias Value = RawEnum
        let key: String = "rawFoo"
    }
    
    struct RawBar: DefaultedRawRepresentablePrefKey {
        typealias Value = RawEnum
        let key: String = "rawBar"
        let defaultValue: Value = .one
    }
    
    class UserDefaultsSchema: PrefsSchema {
        let storage: UserDefaults
        
        init(storage: UserDefaults) {
            self.storage = storage
        }
        
        lazy var foo = pref(Foo())
        lazy var bar = pref(Bar())
        lazy var rawFoo = pref(RawFoo())
        lazy var rawBar = pref(RawBar())
    }
    
    let schema: UserDefaultsSchema
    
    @Test func basicPrefKey() async throws {
        #expect(schema.foo.value == nil)
        
        schema.foo.value = false
        #expect(schema.foo.value == false)
        
        schema.foo.value = true
        #expect(schema.foo.value == true)
        
        schema.foo.value = nil
        #expect(schema.foo.value == nil)
    }
    
    @Test func basicDefaultedPrefKey() async throws {
        #expect(schema.bar.value == true)
        
        schema.bar.value = false
        #expect(schema.bar.value == false)
        
        schema.bar.value = true
        #expect(schema.bar.value == true)
        
        // can't set nil
    }
    
    @Test func rawRepresentablePrefKey() async throws {
        #expect(schema.rawFoo.value == nil)
        
        schema.rawFoo.value = .one
        #expect(schema.rawFoo.value == .one)
        
        schema.rawFoo.value = .two
        #expect(schema.rawFoo.value == .two)
        
        schema.rawFoo.value = nil
        #expect(schema.rawFoo.value == nil)
    }
    
    @Test func defaultedRawRepresentablePrefKey() async throws {
        #expect(schema.rawBar.value == .one)
        
        schema.rawBar.value = .one
        #expect(schema.rawBar.value ==  .one)
        
        schema.rawBar.value = .two
        #expect(schema.rawBar.value == .two)
        
        // can't set nil
    }
}
