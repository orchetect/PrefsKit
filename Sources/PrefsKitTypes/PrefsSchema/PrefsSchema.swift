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
    associatedtype SchemaStorage: PrefsStorage
    
    /// Storage provider for prefs.
    var storage: SchemaStorage { get }
    
    /// Storage mode for prefs.
    var storageMode: PrefsSchemaMode { get }
}
