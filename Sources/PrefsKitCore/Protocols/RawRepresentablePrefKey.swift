//
//  RawRepresentablePrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

/// A prefs key that encodes and decodes its raw storage value to a separate type.
public protocol RawRepresentablePrefKey<Value, StorageValue>: PrefKey
where Value: RawRepresentable, Value: Hashable, Value.RawValue == StorageValue { }

extension RawRepresentablePrefKey {
    public func getValue(in storage: PrefsStorage) -> Value? {
        guard let rawValue = getStorageValue(in: storage) else { return nil }
        return Value(rawValue: rawValue)
    }
    
    public func setValue(to newValue: Value?, in storage: PrefsStorage) {
        setStorageValue(to: newValue?.rawValue, in: storage)
    }
}
