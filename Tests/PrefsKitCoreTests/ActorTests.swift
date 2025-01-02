//
//  ActorTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitCore
import Testing

@Suite
struct ActorTests {
    // Note:
    //
    // Can't attach @MainActor to the class because there are
    // protocol requirements that can't be satisfied in that case
    //
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @PrefsSchema final class TestSchema: @unchecked Sendable {
        @Storage var storage = .dictionary
        @StorageMode var storageMode = .cachedReadStorageWrite

        @MainActor @Pref var foo: Int? // <-- can attach to individual properties
        @Pref var bar: String?
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func baseline() {
        let prefs = TestSchema()
        
        Task { @MainActor in prefs.foo = 1 } // <-- needs MainActor context
        prefs.bar = "a string"
    }
}
