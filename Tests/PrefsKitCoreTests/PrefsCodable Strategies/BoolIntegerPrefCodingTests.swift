//
//  BoolIntegerPrefCodingTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitCore
import Testing

@Suite
struct BoolIntegerPrefCodingTests {
    enum MyType: RawRepresentable {
        case yes
        case no
        
        init?(rawValue: Bool) {
            self = rawValue ? .yes : .no
        }
        
        var rawValue: Bool {
            switch self {
            case .yes: true
            case .no: false
            }
        }
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .storageOnly // important for unit tests in this file!
        
        // MARK: - Static Constructors
        
        @Pref(coding: .boolAsInteger(decodingStrategy: .strict)) var boolIntStrict: Bool?
        
        @Pref(coding: .boolAsInteger(decodingStrategy: .nearest)) var boolIntNearest: Bool?
        
        // MARK: - Chaining Constructor
        
        @Pref(coding: MyType
            .rawRepresentablePrefsCoding
            .boolAsInteger(decodingStrategy: .strict)
        ) var boolIntStrictChained: MyType?
        
        @Pref(coding: MyType
            .rawRepresentablePrefsCoding
            .boolAsInteger(decodingStrategy: .nearest)
        ) var boolIntNearestChained: MyType?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolIntStrict() {
        let schema = TestSchema()
        
        schema.boolIntStrict = true
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrict") == 1)
        #expect(schema.boolIntStrict == true)
        
        schema.boolIntStrict = false
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrict") == 0)
        #expect(schema.boolIntStrict == false)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntStrict", to: 2) // > 1
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrict") == 2)
        #expect(schema.boolIntStrict == nil)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntStrict", to: -1) // < 0
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrict") == -1)
        #expect(schema.boolIntStrict == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolIntNearest() {
        let schema = TestSchema()
        
        schema.boolIntNearest = true
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearest") == 1)
        #expect(schema.boolIntNearest == true)
        
        schema.boolIntNearest = false
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearest") == 0)
        #expect(schema.boolIntNearest == false)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntNearest", to: 2) // > 1
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearest") == 2)
        #expect(schema.boolIntNearest == true)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntNearest", to: -1) // < 0
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearest") == -1)
        #expect(schema.boolIntNearest == false)
    }
    
    // MARK: - Chaining Constructor
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolIntStrictChained() {
        let schema = TestSchema()
        
        schema.boolIntStrictChained = .yes
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrictChained") == 1)
        #expect(schema.boolIntStrictChained == .yes)
        
        schema.boolIntStrictChained = .no
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrictChained") == 0)
        #expect(schema.boolIntStrictChained == .no)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntStrictChained", to: 2) // > 1
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrictChained") == 2)
        #expect(schema.boolIntStrict == nil)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntStrictChained", to: -1) // < 0
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntStrictChained") == -1)
        #expect(schema.boolIntStrict == nil)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func boolIntNearestChained() {
        let schema = TestSchema()
        
        schema.boolIntNearestChained = .yes
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearestChained") == 1)
        #expect(schema.boolIntNearestChained == .yes)
        
        schema.boolIntNearestChained = .no
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearestChained") == 0)
        #expect(schema.boolIntNearestChained == .no)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntNearestChained", to: 2) // > 1
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearestChained") == 2)
        #expect(schema.boolIntNearestChained == .yes)
        
        schema.storage.setStorageValue<Int>(forKey: "boolIntNearestChained", to: -1) // < 0
        #expect(schema.storage.storageValue<Int>(forKey: "boolIntNearestChained") == -1)
        #expect(schema.boolIntNearestChained == .no)
    }
}
