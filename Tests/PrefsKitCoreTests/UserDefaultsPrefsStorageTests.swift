//
//  UserDefaultsPrefsStorageTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitCore
import Testing

@Suite(.serialized)
struct UserDefaultsPrefsStorageTests {
    static let domain = { "com.orchetect.PrefsKit.\(type(of: Self.self))" }()
    
    static func testSuite() -> UserDefaults {
        UserDefaults(suiteName: domain)!
    }
    
    let storage: UserDefaultsPrefsStorage
    
    // MARK: - Init
    
    init() {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        storage = UserDefaultsPrefsStorage(suite: Self.testSuite())
    }
    
    // MARK: - Mock Types
    
    enum RawEnum: String, RawRepresentable {
        case one
        case two
    }
    
    enum CodableEnum: String, Codable {
        case one
        case two
    }
    
    // MARK: - Protocol Adoptions
    
    struct Foo: AtomicPrefKey {
        let key: String = "foo"
        
        typealias Value = Bool
    }
    
    struct Bar: AtomicDefaultedPrefKey {
        let key: String = "bar"
        
        typealias Value = Bool
        let defaultValue: Value = true
    }
    
    struct RawFoo: RawRepresentablePrefKey {
        let key: String = "rawFoo"
        
        typealias Value = RawEnum
        // typealias StorageValue = RawEnum.RawValue // inferred
    }
    
    struct RawBar: DefaultedRawRepresentablePrefKey {
        let key: String = "rawBar"
        
        typealias Value = RawEnum
        // typealias StorageValue = RawEnum.RawValue // inferred
        let defaultValue: Value = .one
    }
    
    struct CodableFoo: CodablePrefKey {
        let key: String = "codableFoo"
        
        typealias Value = CodableEnum
        // typealias StorageValue // inferred from encoder/decoder
        
        func prefEncoder() -> JSONEncoder { JSONEncoder() }
        func prefDecoder() -> JSONDecoder { JSONDecoder() }
    }
    
    struct CodableBar: DefaultedCodablePrefKey {
        let key: String = "codableBar"
        
        typealias Value = CodableEnum
        // typealias StorageValue // inferred from encoder/decoder
        let defaultValue: Value = .one
        
        func prefEncoder() -> JSONEncoder { JSONEncoder() }
        func prefDecoder() -> JSONDecoder { JSONDecoder() }
    }
    
    struct JSONCodableFoo: JSONCodablePrefKey {
        let key: String = "jsonCodableFoo"
        
        typealias Value = CodableEnum
    }
    
    struct JSONCodableBar: DefaultedJSONCodablePrefKey {
        let key: String = "jsonCodableBar"
        
        typealias Value = CodableEnum
        let defaultValue: Value = .one
    }
    
    let foo = Foo()
    let bar = Bar()
    let rawFoo = RawFoo()
    let rawBar = RawBar()
    let codableFoo = CodableFoo()
    let codableBar = CodableBar()
    let jsonCodableFoo = JSONCodableFoo()
    let jsonCodableBar = JSONCodableBar()
    
    // MARK: - Tests
    
    @Test func atomicPrefKey() async throws {
        #expect(foo.getValue(in: storage) == nil)
        
        foo.setValue(to: false, in: storage)
        #expect(foo.getValue(in: storage) == false)
        
        foo.setValue(to: true, in: storage)
        #expect(foo.getValue(in: storage) == true)
        
        foo.setValue(to: nil, in: storage)
        #expect(foo.getValue(in: storage) == nil)
    }
    
    @Test func atomicDefaultedPrefKey() async throws {
        #expect(bar.getValue(in: storage) == nil)
        #expect(bar.getDefaultedValue(in: storage) == true)
        
        bar.setValue(to: false, in: storage)
        #expect(bar.getValue(in: storage) == false)
        #expect(bar.getDefaultedValue(in: storage) == false)
        
        bar.setValue(to: true, in: storage)
        #expect(bar.getValue(in: storage) == true)
        #expect(bar.getDefaultedValue(in: storage) == true)
        
        bar.setValue(to: nil, in: storage)
        #expect(bar.getValue(in: storage) == nil)
        #expect(bar.getDefaultedValue(in: storage) == true)
    }
    
    @Test func rawRepresentablePrefKey() async throws {
        #expect(rawFoo.getValue(in: storage) == nil)
        
        rawFoo.setValue(to: .one, in: storage)
        #expect(rawFoo.getValue(in: storage) == .one)
        
        rawFoo.setValue(to: .two, in: storage)
        #expect(rawFoo.getValue(in: storage) == .two)
        
        rawFoo.setValue(to: nil, in: storage)
        #expect(rawFoo.getValue(in: storage) == nil)
    }
    
    @Test func defaultedRawRepresentablePrefKey() async throws {
        #expect(rawBar.getValue(in: storage) == nil)
        #expect(rawBar.getDefaultedValue(in: storage) == .one)
        
        rawBar.setValue(to: .one, in: storage)
        #expect(rawBar.getValue(in: storage) ==  .one)
        #expect(rawBar.getDefaultedValue(in: storage) ==  .one)
        
        rawBar.setValue(to: .two, in: storage)
        #expect(rawBar.getValue(in: storage) == .two)
        #expect(rawBar.getDefaultedValue(in: storage) == .two)
        
        rawBar.setValue(to: nil, in: storage)
        #expect(rawBar.getValue(in: storage) == nil)
        #expect(rawBar.getDefaultedValue(in: storage) == .one)
    }
    
    @Test func codablePrefKey() async throws {
        #expect(codableFoo.getValue(in: storage) == nil)
        
        codableFoo.setValue(to: .one, in: storage)
        #expect(codableFoo.getValue(in: storage) == .one)
        
        codableFoo.setValue(to: .two, in: storage)
        #expect(codableFoo.getValue(in: storage) == .two)
        
        codableFoo.setValue(to: nil, in: storage)
        #expect(codableFoo.getValue(in: storage) == nil)
    }
    
    @Test func defaultedCodablePrefKey() async throws {
        #expect(codableBar.getValue(in: storage) == nil)
        #expect(codableBar.getDefaultedValue(in: storage) == .one)
        
        codableBar.setValue(to: .one, in: storage)
        #expect(codableBar.getValue(in: storage) ==  .one)
        #expect(codableBar.getDefaultedValue(in: storage) ==  .one)
        
        codableBar.setValue(to: .two, in: storage)
        #expect(codableBar.getValue(in: storage) == .two)
        #expect(codableBar.getDefaultedValue(in: storage) == .two)
        
        codableBar.setValue(to: nil, in: storage)
        #expect(codableBar.getValue(in: storage) == nil)
        #expect(codableBar.getDefaultedValue(in: storage) == .one)
    }
    
    @Test func jsonCodablePrefKey() async throws {
        #expect(jsonCodableFoo.getValue(in: storage) == nil)
        
        jsonCodableFoo.setValue(to: .one, in: storage)
        #expect(jsonCodableFoo.getValue(in: storage) == .one)
        
        jsonCodableFoo.setValue(to: .two, in: storage)
        #expect(jsonCodableFoo.getValue(in: storage) == .two)
        
        jsonCodableFoo.setValue(to: nil, in: storage)
        #expect(jsonCodableFoo.getValue(in: storage) == nil)
    }
    
    @Test func defaultedJSONCodablePrefKey() async throws {
        #expect(jsonCodableBar.getValue(in: storage) == nil)
        #expect(jsonCodableBar.getDefaultedValue(in: storage) == .one)
        
        jsonCodableBar.setValue(to: .one, in: storage)
        #expect(jsonCodableBar.getValue(in: storage) ==  .one)
        #expect(jsonCodableBar.getDefaultedValue(in: storage) ==  .one)
        
        jsonCodableBar.setValue(to: .two, in: storage)
        #expect(jsonCodableBar.getValue(in: storage) == .two)
        #expect(jsonCodableBar.getDefaultedValue(in: storage) == .two)
        
        jsonCodableBar.setValue(to: nil, in: storage)
        #expect(jsonCodableBar.getValue(in: storage) == nil)
        #expect(jsonCodableBar.getDefaultedValue(in: storage) == .one)
    }
}
