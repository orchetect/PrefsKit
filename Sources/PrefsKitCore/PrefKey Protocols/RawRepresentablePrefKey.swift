//
//  RawRepresentablePrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A prefs key that encodes and decodes its raw storage value to a separate type.
public protocol RawRepresentablePrefKey: PrefKey
where Value: RawRepresentable,
      Value.RawValue == StorageValue { }

extension RawRepresentablePrefKey {
    public func getValue(in storage: PrefsStorage) -> Value? {
        guard let rawValue = getStorageValue(in: storage) else { return nil }
        return Value(rawValue: rawValue)
    }
    
    public func setValue(to newValue: Value?, in storage: PrefsStorage) {
        setStorageValue(to: newValue?.rawValue, in: storage)
    }
}
