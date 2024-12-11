//
//  PrefsCodable+RawRepresentable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsCodable where Value: RawRepresentable, Value.RawValue == StorageValue {
    public func getValue(forKey key: String, in storage: PrefsStorage) -> Value? {
        guard let rawValue = getStorageValue(forKey: key, in: storage) else { return nil }
        return Value(rawValue: rawValue)
    }
    
    public func setValue(forKey key: String, to newValue: Value?, in storage: PrefsStorage) {
        setStorageValue(forKey: key, to: newValue?.rawValue, in: storage)
    }
}
