//
//  PrefsCodable+RawRepresentable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension PrefsCodable where Value: RawRepresentable, Value.RawValue == StorageValue {
    public func decode(prefsValue: StorageValue) -> Value? {
        Value(rawValue: prefsValue)
    }
    
    public func encode(prefsValue: Value) -> StorageValue? {
        prefsValue.rawValue
    }
}
