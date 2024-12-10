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
        typealias Value = Bool
        let key: String = "foo"
    }
    
    struct Bar: AtomicDefaultedPrefKey {
        typealias Value = Bool
        let key: String = "bar"
        let defaultValue: Value = true
    }
    
    struct RawFoo: PrefKey {
        typealias Value = RawEnum // RawRepresentable
        typealias StorageValue = RawEnum.RawValue
        let key: String = "rawFoo"
    }
    
    struct RawBar: DefaultedPrefKey {
        typealias Value = RawEnum // RawRepresentable
        typealias StorageValue = RawEnum.RawValue
        let key: String = "rawBar"
        let defaultValue: Value = .one
    }
    
    struct CodableFoo: JSONCodablePrefKey {
        typealias Value = CodableEnum
        let key: String = "codableFoo"
    }
    
    struct CodableBar: DefaultedJSONCodablePrefKey {
        typealias Value = CodableEnum
        let key: String = "codableBar"
        let defaultValue: Value = .one
    }
    
    let foo = Foo()
    let bar = Bar()
    let rawFoo = RawFoo()
    let rawBar = RawBar()
    let codableFoo = CodableFoo()
    let codableBar = CodableBar()
    
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
}
