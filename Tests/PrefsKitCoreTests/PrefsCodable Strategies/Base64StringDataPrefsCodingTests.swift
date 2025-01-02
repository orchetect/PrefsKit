//
//  Base64StringDataPrefsCodingTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitCore
import Testing

@Suite
struct Base64StringDataPrefsCodingTests {
    struct MyType: Equatable, Codable {
        var id: Int
        var name: String
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .storageOnly // important for unit tests in this file!
        
        // MARK: - Static Constructors
        
        @Pref(coding: .base64DataString()) var data: Data?
        
        // MARK: - Chaining Constructor
        
        @Pref(coding: MyType.jsonDataPrefsCoding.base64DataString()) var myTypeChained: MyType?
    }
    
    // MARK: - Static Constructors
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func data() async throws {
        let schema = TestSchema()
        
        let testData = Data([0x01, 0x02, 0x03])
        
        schema.data = testData
        #expect(schema.storage.storageValue<String>(forKey: "data") == "AQID")
        #expect(schema.data == testData)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func myTypeChained() async throws {
        let schema = TestSchema()
        
        let testType = MyType(id: 123, name: "foo")
        
        schema.myTypeChained = testType
        let getString: String = try #require(schema.storage.storageValue<String>(forKey: "myTypeChained"))
        // just check for non-empty content, we won't check actual content since it's not fully deterministic
        #expect(getString.count > 10)
        #expect(schema.myTypeChained == testType)
    }
}
