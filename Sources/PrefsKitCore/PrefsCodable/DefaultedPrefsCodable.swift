//
//  DefaultedPrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that provides a default value.
public protocol DefaultedPrefsCodable: PrefsCodable {
    /// Default value to return if the key does not exist or its value is mismatched.
    var defaultValue: Value { get }
    
    /// Returns the current stored value.
    /// Returns the ``defaultValue`` if the key does not exist or its value is mismatched.
    func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Value
}

extension DefaultedPrefsCodable {
    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Value {
        getValue(forKey: key, in: storage) ?? defaultValue
    }
}
