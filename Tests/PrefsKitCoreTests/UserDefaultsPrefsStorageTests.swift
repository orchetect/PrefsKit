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
    
    init() {
        UserDefaults.standard.removePersistentDomain(forName: Self.domain)
        storage = UserDefaultsPrefsStorage(suite: Self.testSuite())
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
    
    let foo = Foo()
    let bar = Bar()
    let rawFoo = RawFoo()
    let rawBar = RawBar()
    
    @Test func basicPrefKey() async throws {
        #expect(foo.getValue(in: storage) == nil)
        
        foo.setValue(to: false, in: storage)
        #expect(foo.getValue(in: storage) == false)
        
        foo.setValue(to: true, in: storage)
        #expect(foo.getValue(in: storage) == true)
        
        foo.setValue(to: nil, in: storage)
        #expect(foo.getValue(in: storage) == nil)
    }
    
    @Test func basicDefaultedPrefKey() async throws {
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
}
