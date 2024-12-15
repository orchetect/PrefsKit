//
//  PrefsCodable Prototypes.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

public struct AtomicPrefsCoding<Value>: AtomicPrefsCodable
where Value: PrefsStorageValue {
    public typealias Value = Value
    
    public init() { }
}

public struct PrefsCoding<Value, StorageValue>: PrefsCodable
    where Value: Sendable, StorageValue: PrefsStorageValue
{
    let encodeBlock: @Sendable (Value) -> StorageValue?
    let decodeBlock: @Sendable (StorageValue) -> Value?
    
    public init(
        encode: @escaping @Sendable (Value) -> StorageValue?,
        decode: @escaping @Sendable (StorageValue) -> Value?
    ) {
        encodeBlock = encode
        decodeBlock = decode
    }
    
    public func decode(prefsValue: StorageValue) -> Value? {
        decodeBlock(prefsValue)
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        encodeBlock(prefsValue)
    }
}

public struct RawRepresentablePrefsCoding<Value>: RawRepresentablePrefsCodable
    where Value: Sendable, Value: RawRepresentable, Value.RawValue: PrefsStorageValue
{
    public typealias Value = Value
    public typealias StorageValue = Value.RawValue
    
    public init() { }
}

public struct CodablePrefsCoding<Value, StorageValue, Encoder, Decoder>: CodablePrefsCodable
    where Value: Codable, Value: Sendable,
    StorageValue: PrefsStorageValue, StorageValue == Encoder.Output,
    Encoder: TopLevelEncoder, Encoder: Sendable, Encoder.Output: PrefsStorageValue,
    Decoder: TopLevelDecoder, Decoder: Sendable, Decoder.Input: PrefsStorageValue,
    Encoder.Output == Decoder.Input
{
    public typealias Value = Value
    public typealias StorageValue = StorageValue
    public typealias Encoder = Encoder
    public typealias Decoder = Decoder
    let encoder: Encoder
    let decoder: Decoder
    
    public init(
        value: Value.Type,
        storageValue: StorageValue.Type,
        encoder: @escaping @Sendable @autoclosure () -> Encoder,
        decoder: @escaping @Sendable @autoclosure () -> Decoder
    ) {
        self.encoder = encoder()
        self.decoder = decoder()
    }
    
    public func prefsEncoder() -> Encoder { encoder }
    public func prefsDecoder() -> Decoder { decoder }
}

public struct JSONCodablePrefsCoding<Value>: JSONCodablePrefsCodable
    where Value: Codable, Value: Sendable
{
    public typealias Value = Value
    
    public init() { }
}
