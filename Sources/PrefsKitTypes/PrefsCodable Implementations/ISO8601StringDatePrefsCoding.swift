//
//  ISO8601DateStringPrefsCoding.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension PrefsCodable where Self == ISO8601DateStringPrefsCoding {
    /// Coding strategy for `Date` using standard ISO-8601 format `String` as the encoded storage value.
    ///
    /// For example:
    ///
    /// ```
    /// 2024-12-31T21:30:35Z
    /// ```
    ///
    /// > Important:
    /// >
    /// > This format includes date and time with a resolution of 1 second. Any sub-second time information is truncated
    /// > and discarded.
    ///
    /// > Note:
    /// >
    /// > `Date` has native `Codable` conformance, which means it may also be used directly with
    /// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
    public static var iso8601DateString: ISO8601DateStringPrefsCoding { .init() }
}

/// Coding strategy for `Date` using standard ISO-8601 format `String` as the encoded storage value.
///
/// For example:
///
/// ```
/// 2024-12-31T21:30:35Z
/// ```
///
/// > Important:
/// >
/// > This format includes date and time with a resolution of 1 second. Any sub-second time information is truncated
/// > and discarded.
///
/// > Note:
/// >
/// > `Date` has native `Codable` conformance, which means it may also be used directly with
/// > `@JSONDataCodablePref` or `@JSONStringCodablePref`.
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct ISO8601DateStringPrefsCoding: PrefsCodable {
    public func encode(prefsValue: Date) -> String? {
        prefsValue.ISO8601Format()
    }
    
    public func decode(prefsValue: String) -> Date? {
        try? Date(prefsValue, strategy: .iso8601)
    }
}
