//
//  PrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Defines value encoding and decoding for reading and writing to prefs storage.
public protocol PrefsCodable<Value, StorageValue>: Sendable
where Value: Sendable, StorageValue: PrefsStorageValue {
    associatedtype Value
    associatedtype StorageValue
    
    /// Decodes a raw atomic prefs storage value to a value.
    func decode(prefsValue: StorageValue) -> Value?
    
    /// Encodes a value to a raw atomic prefs storage value.
    func encode(prefsValue: Value) -> StorageValue?
}

extension PrefsCodable where Value == StorageValue {
    public func decode(prefsValue: StorageValue) -> Value? {
        prefsValue
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        prefsValue
    }
}
