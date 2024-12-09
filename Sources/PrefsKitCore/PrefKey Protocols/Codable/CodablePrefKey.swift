//
//  CodablePrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage.
public protocol CodablePrefKey<Encoder, Decoder>: PrefKey
    where Value: Codable,
    StorageValue == Encoder.Output,
    Encoder.Output: PrefStorageValue,
    Decoder.Input: PrefStorageValue,
    Encoder.Output == Decoder.Input
{
    associatedtype Encoder: TopLevelEncoder
    associatedtype Decoder: TopLevelDecoder
    
    /// Return a new instance of the encoder used to encode the type for prefs storage.
    func prefEncoder() -> Encoder
    
    /// Return a new instance of the decoder used to decode the type from prefs storage.
    func prefDecoder() -> Decoder
}

extension CodablePrefKey {
    public func getValue(in storage: PrefsStorage) -> Value? {
        guard let rawValue = getStorageValue(in: storage) else { return nil }
        
        let decoder = prefDecoder()
        guard let value = try? decoder.decode(Value.self, from: rawValue) else { return nil }
        return value
    }
    
    public func setValue(to newValue: Value?, in storage: PrefsStorage) {
        guard let newValue else {
            storage.setValue(to: nil, forKey: self)
            return
        }
        
        let encoder = prefEncoder()
        guard let encoded = try? encoder.encode(newValue) else { return }
        setStorageValue(to: encoded, in: storage)
    }
}
