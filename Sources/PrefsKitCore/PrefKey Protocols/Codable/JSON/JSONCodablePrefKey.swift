//
//  JSONCodablePrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage using JSON encoding.
public protocol JSONCodablePrefKey: CodablePrefKey
where Encoder == JSONEncoder, Decoder == JSONDecoder { }

extension JSONCodablePrefKey {
    public func prefEncoder() -> Encoder {
        JSONEncoder()
    }

    public func prefDecoder() -> Decoder {
        JSONDecoder()
    }
}
