//
//  CustomEncodingTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import PrefsKitCore
import Testing

@Suite
struct CustomEncodingTests {
    struct NonCodableNonRawRepresentable: Equatable {
        var value: Int
        
        init(value: Int) {
            self.value = value
        }
        
        init?(encoded: String) {
            guard encoded.hasPrefix("VALUE:"),
                  let val = Int(encoded.dropFirst(6))
            else { return nil }
            value = val
        }
        
        func encoded() -> String {
            "VALUE:(\(value))"
        }
    }
    
    struct CustomPrefKey: PrefKey {
        typealias Value = NonCodableNonRawRepresentable
        typealias StorageValue = String
        
        var key: String = "customKey"
        
        func getValue(in storage: any PrefsStorage) -> NonCodableNonRawRepresentable? {
            guard let rawValue = storage.value(forKey: self),
                  let instance = NonCodableNonRawRepresentable(encoded: rawValue)
            else { return nil }
            
            return instance
        }
        
        func setValue(to newValue: NonCodableNonRawRepresentable?, in storage: any PrefsStorage) {
            storage.setValue(to: newValue?.encoded(), forKey: self)
        }
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    final class TestSchema: PrefsSchema, @unchecked Sendable {
        let storage: any PrefsStorage = DictionaryPrefsStorage()
        
        enum Key: String, CaseIterable {
            case custom
        }
        
        lazy var customKey = pref(CustomPrefKey())
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test func customValueEncoding() {
        let schema = TestSchema()
        
        #expect(schema.customKey.value?.value == nil)
        
        schema.customKey.value = NonCodableNonRawRepresentable(value: 42)
        #expect(schema.customKey.value?.value == 42)
        
        schema.customKey.value?.value = 5
        #expect(schema.customKey.value?.value == 5)
        
        schema.customKey.value = nil
        #expect(schema.customKey.value == nil)
    }
}