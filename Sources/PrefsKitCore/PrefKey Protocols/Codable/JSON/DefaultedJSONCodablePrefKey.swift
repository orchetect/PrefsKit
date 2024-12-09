//
//  DefaultedJSONCodablePrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that encodes and decodes a `Codable` type to/from raw storage using JSON encoding
/// and provides a default value.
public protocol DefaultedJSONCodablePrefKey: JSONCodablePrefKey, DefaultedCodablePrefKey { }
