//
//  PrefsStorageError.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum PrefsStorageError: LocalizedError {
    case contentLoadingNotSupported
    case plistLoadingNotSupported
    case plistWritingNotSupported
    
    public var errorDescription: String? {
        switch self {
        case .contentLoadingNotSupported:
            "Loading content is not supported for this prefs storage implementation."
        case .plistLoadingNotSupported:
            "Conversion from plist format is not supported for this prefs storage implementation."
        case .plistWritingNotSupported:
            "Conversion to plist format is not supported for this prefs storage implementation."
        }
    }
}
