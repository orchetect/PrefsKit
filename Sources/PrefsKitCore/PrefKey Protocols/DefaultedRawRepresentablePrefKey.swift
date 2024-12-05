//
//  DefaultedRawRepresentablePrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

/// A prefs key that encodes and decodes its raw storage value to a separate type and provides a default value.
public protocol DefaultedRawRepresentablePrefKey<Value, StorageValue>: RawRepresentablePrefKey, DefaultedPrefKey
where Value: RawRepresentable, Value: Hashable, Value.RawValue == StorageValue { }

extension DefaultedRawRepresentablePrefKey {
    public func getDefaultedValue(in storage: PrefsStorage) -> Value {
        guard let rawRepValue = getValue(in: storage)
        else { return defaultValue }
        
        return rawRepValue
    }
}
