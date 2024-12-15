//
//  PrefsSchemaModeWrapper.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// Pref schema property access storage mode.
@propertyWrapper
public struct PrefsSchemaModeWrapper {
    public var wrappedValue: PrefsSchemaMode
    
    public init(wrappedValue: PrefsSchemaMode) {
        self.wrappedValue = wrappedValue
    }
    
    public init(_ mode: PrefsSchemaMode) {
        self.wrappedValue = mode
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension PrefsSchema {
    /// Pref schema property access storage mode.
    public typealias StorageMode = PrefsSchemaModeWrapper
}