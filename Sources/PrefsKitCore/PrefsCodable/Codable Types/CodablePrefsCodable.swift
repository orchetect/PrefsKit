//
//  CodablePrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage.
///
/// > Tip:
/// > It is suggested that if all `Codable` types that are to be stored in prefs storage use
/// > the same encoder/decoder, that you create a protocol that inherits from ``CodablePrefsCodable``
/// > for all non-defaulted `Codable` prefs and then implement `prefEncoder()` and `prefDecoder()` to return
/// > the same instances. These types can then adopt this new protocol.
public protocol CodablePrefsCodable<Encoder, Decoder>: PrefsCodable
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

extension CodablePrefsCodable {
    public func getValue(forKey key: String, in storage: PrefsStorage) -> Value? {
        guard let rawValue = getStorageValue(forKey: key, in: storage) else { return nil }
        
        let decoder = prefDecoder()
        guard let value = try? decoder.decode(Value.self, from: rawValue) else { return nil }
        return value
    }
    
    public func setValue(forKey key: String, to newValue: Value?, in storage: PrefsStorage) {
        guard let newValue else {
            storage.setValue(forKey: key, to: StorageValue?.none)
            return
        }
        
        let encoder = prefEncoder()
        guard let encoded = try? encoder.encode(newValue) else { return }
        setStorageValue(forKey: key, to: encoded, in: storage)
    }
}
