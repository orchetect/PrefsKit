//
//  DefaultedRawRepresentablePrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that encodes and decodes its raw storage value to a separate type and provides a default value.
public protocol DefaultedRawRepresentablePrefKey<Value, StorageValue>: RawRepresentablePrefKey, DefaultedPrefKey { }

extension DefaultedRawRepresentablePrefKey {
    public func getDefaultedValue(in storage: PrefsStorage) -> Value {
        guard let rawRepValue = getValue(in: storage)
        else { return defaultValue }
        
        return rawRepValue
    }
}
