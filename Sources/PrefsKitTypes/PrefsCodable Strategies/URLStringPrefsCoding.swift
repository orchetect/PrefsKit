//
//  URLStringPrefsCoding.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsCodable where Self == URLStringPrefsCoding {
    /// Coding strategy for `URL` using absolute `String` as the encoded storage value type.
    ///
    /// > Tip:
    /// >
    /// > `URL` has native `Codable` conformance, which means it may also be used directly with
    /// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
    public static var urlString: URLStringPrefsCoding { .init() }
}

/// Coding strategy for `URL` using absolute `String` as the encoded storage value type.
///
/// > Tip:
/// >
/// > `URL` has native `Codable` conformance, which means it may also be used directly with
/// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
public struct URLStringPrefsCoding: PrefsCodable {
    public init() { }
    
    public func encode(prefsValue: URL) -> String? {
        prefsValue.absoluteString
    }

    public func decode(prefsValue: String) -> URL? {
        URL(string: prefsValue)
    }
}
