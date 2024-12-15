//
//  PrefsSchemaPrefsStorageTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitCore
import Testing

@Suite
struct PrefsSchemaStorageMacroTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchemaA: @unchecked Sendable {
        @Storage var storage = DictionaryPrefsStorage()
        @StorageMode var storageMode = .cachedReadStorageWrite

        @Pref var foo: Int?
    }
    
    /// Note: public access level
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema public final class TestSchemaB: @unchecked Sendable {
        @Storage public var storage = .dictionary
        @StorageMode public var storageMode = .cachedReadStorageWrite
        
        @Pref public var foo: Int?
    }
    
    /// No logic testing. Just ensure compiler is happy.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test func instantiate() {
        let _ = TestSchemaA()
        let _ = TestSchemaB()
    }
}
