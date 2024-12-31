//
//  ChainingEncodingStrategiesTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitCore
import Testing

@Suite
struct ChainingEncodingStrategiesTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        let storage = DictionaryPrefsStorage()
        let storageMode: PrefsStorageMode = .cachedReadStorageWrite
        
        @Pref(coding: .compressedData(algorithm: .lzfse).base64DataString()) public var foo: Data?
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func chainedEncoding() async throws {
        let schema = TestSchema()
        
        let testData = Data((1 ... 100).map(\.self))
        
        schema.foo = testData
        
        let encoded: String = try #require(schema.storage.storageValue(forKey: "foo"))
        
        // check that the storage value is the base-64 string of the compressed data
        #expect(
            encoded ==
                "YnZ4LWQAAAABAgMEBQYHCAkKCwwNDg8QERITFBUW"
                + "FxgZGhscHR4fICEiIyQlJicoKSorLC0uLzAxMjM0"
                + "NTY3ODk6Ozw9Pj9AQUJDREVGR0hJSktMTU5PUFFS"
                + "U1RVVldYWVpbXF1eX2BhYmNkYnZ4JA=="
        )
        
        let decoded = try #require(schema.foo)
        
        #expect(decoded == testData)
    }
}
