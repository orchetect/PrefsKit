//
//  DefaultedCodablePrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage and provides a default value.
///
/// > Tip:
/// > It is suggested that if all `Codable` types that are to be stored in prefs storage use
/// > the same encoder/decoder, that you create a protocol that inherits from ``DefaultedCodablePrefKey``
/// > for all defaulted `Codable` prefs and then implement `prefEncoder()` and `prefDecoder()` to return
/// > the same instances. These types can then adopt this new protocol.
public protocol DefaultedCodablePrefKey: CodablePrefKey, DefaultedPrefKey { }
