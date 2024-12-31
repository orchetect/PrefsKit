//
//  Base64StringDataPrefsCoding.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsCodable where Self == Base64StringDataPrefsCoding {
    /// Coding strategy for `Data` using base-64 encoded `String` as the encoded storage value.
    public static func base64DataString(
        encodingOptions: Data.Base64EncodingOptions = [],
        decodingOptions: Data.Base64DecodingOptions = []
    ) -> Base64StringDataPrefsCoding {
        Base64StringDataPrefsCoding(encodingOptions: encodingOptions, decodingOptions: decodingOptions)
    }
}

/// Coding strategy for `Data` using base-64 encoded `String` as the encoded storage value.
public struct Base64StringDataPrefsCoding: PrefsCodable {
    public let encodingOptions: Data.Base64EncodingOptions
    public let decodingOptions: Data.Base64DecodingOptions
    
    public func encode(prefsValue: Data) -> String? {
        prefsValue.base64EncodedString(options: encodingOptions)
    }

    public func decode(prefsValue: String) -> Data? {
        Data(base64Encoded: prefsValue, options: decodingOptions)
    }
}
