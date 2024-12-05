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
    let testSuite: UserDefaults
    
    init() {
        let domain = "com.orchetect.PrefsKit.\(type(of: self))"
        UserDefaults.standard.removePersistentDomain(forName: domain)
        testSuite = UserDefaults(suiteName: domain)!
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
        let defaultValue: StorageValue = true
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
        #expect(foo.getValue(in: testSuite) == nil)
        
        foo.setValue(to: false, in: testSuite)
        #expect(foo.getValue(in: testSuite) == false)
        
        foo.setValue(to: true, in: testSuite)
        #expect(foo.getValue(in: testSuite) == true)
        
        foo.setValue(to: nil, in: testSuite)
        #expect(foo.getValue(in: testSuite) == nil)
    }
    
    @Test func basicDefaultedPrefKey() async throws {
        #expect(bar.getValue(in: testSuite) == nil)
        #expect(bar.getDefaultedValue(in: testSuite) == true)
        
        bar.setValue(to: false, in: testSuite)
        #expect(bar.getValue(in: testSuite) == false)
        #expect(bar.getDefaultedValue(in: testSuite) == false)
        
        bar.setValue(to: true, in: testSuite)
        #expect(bar.getValue(in: testSuite) == true)
        #expect(bar.getDefaultedValue(in: testSuite) == true)
        
        bar.setValue(to: nil, in: testSuite)
        #expect(bar.getValue(in: testSuite) == nil)
        #expect(bar.getDefaultedValue(in: testSuite) == true)
    }
    
    @Test func rawRepresentablePrefKey() async throws {
        #expect(rawFoo.getValue(in: testSuite) == nil)
        
        rawFoo.setValue(to: .one, in: testSuite)
        #expect(rawFoo.getValue(in: testSuite) == .one)
        
        rawFoo.setValue(to: .two, in: testSuite)
        #expect(rawFoo.getValue(in: testSuite) == .two)
        
        rawFoo.setValue(to: nil, in: testSuite)
        #expect(rawFoo.getValue(in: testSuite) == nil)
    }
    
    @Test func defaultedRawRepresentablePrefKey() async throws {
        #expect(rawBar.getValue(in: testSuite) == nil)
        #expect(rawBar.getDefaultedValue(in: testSuite) == .one)
        
        rawBar.setValue(to: .one, in: testSuite)
        #expect(rawBar.getValue(in: testSuite) ==  .one)
        #expect(rawBar.getDefaultedValue(in: testSuite) ==  .one)
        
        rawBar.setValue(to: .two, in: testSuite)
        #expect(rawBar.getValue(in: testSuite) == .two)
        #expect(rawBar.getDefaultedValue(in: testSuite) == .two)
        
        rawBar.setValue(to: nil, in: testSuite)
        #expect(rawBar.getValue(in: testSuite) == nil)
        #expect(rawBar.getDefaultedValue(in: testSuite) == .one)
    }
}
