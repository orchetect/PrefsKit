//
//  RawRepresentablePrefsCoding.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs value coding strategy which uses a `RawRepresentable`'s `RawValue` as its storage value.
public struct RawRepresentablePrefsCoding<Value>: RawRepresentablePrefsCodable
where Value: Sendable, Value: RawRepresentable, Value.RawValue: PrefsStorageValue
{
    public typealias Value = Value
    public typealias StorageValue = Value.RawValue
    
    public init() { }
}

// MARK: - Static Constructor

extension RawRepresentable where Self: Sendable, Self.RawValue: PrefsStorageValue {
    /// A prefs value coding strategy which uses a `RawRepresentable`'s `RawValue` as its storage value.
    public static var rawRepresentablePrefsCoding: RawRepresentablePrefsCoding<Self> {
        RawRepresentablePrefsCoding()
    }
}