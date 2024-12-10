//
//  PrefKey+DefaultedPrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefKey where Value: RawRepresentable,
                        Value.RawValue == StorageValue {
    public func getValue(in storage: PrefsStorage) -> Value? {
        guard let rawValue = getStorageValue(in: storage) else { return nil }
        return Value(rawValue: rawValue)
    }
    
    public func setValue(to newValue: Value?, in storage: PrefsStorage) {
        setStorageValue(to: newValue?.rawValue, in: storage)
    }
}
