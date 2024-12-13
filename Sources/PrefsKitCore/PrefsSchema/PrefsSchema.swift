//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// Protocol for prefs schema.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol PrefsSchema /* where Self: Sendable */ {
    /// Storage provider type for prefs.
    associatedtype Storage: PrefsStorage
    
    /// Storage provider for prefs.
    var storage: Storage { get }
    
    /// Enable or disable internal cache of prefs values.
    ///
    /// This is safe (and more performant) to enable when you know that the prefs storage provider (``storage``) will
    /// either:
    /// - never change externally, or
    /// - may change externally but external changes are safe to discard/overwrite with local cached values.
    var isCacheEnabled: Bool { get }
}
