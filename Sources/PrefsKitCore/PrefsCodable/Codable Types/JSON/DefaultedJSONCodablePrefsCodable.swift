//
//  DefaultedJSONCodablePrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage using JSON encoding with default
/// options and provides a default value.
///
/// > Note:
/// > If custom `JSONEncoder`/`JSONDecoder` options are required, override the default implementation(s) of
/// > `prefEncoder()` and/or `prefDecoder()` methods to return an encoder/decoder with necessary options configured.
public protocol DefaultedJSONCodablePrefsCodable: JSONCodablePrefsCodable, DefaultedCodablePrefsCodable { }
