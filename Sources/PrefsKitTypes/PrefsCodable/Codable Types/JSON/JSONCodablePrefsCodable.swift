//
//  JSONCodablePrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw `Data` storage using JSON encoding with default
/// options.
///
/// > Note:
/// > If custom `JSONEncoder`/`JSONDecoder` options are required, override the default implementation(s) of
/// > `prefEncoder()` and/or `prefDecoder()` methods to return an encoder/decoder with necessary options configured.
public protocol JSONCodablePrefsCodable: CodablePrefsCodable
where Encoder == JSONEncoder, Decoder == JSONDecoder, StorageValue == Data { }

extension JSONCodablePrefsCodable {
    public func prefsEncoder() -> JSONEncoder {
        JSONEncoder()
    }

    public func prefsDecoder() -> JSONDecoder {
        JSONDecoder()
    }
}
