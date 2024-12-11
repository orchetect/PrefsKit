//
//  DefaultedPrefsCodable+RawRepresentable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DefaultedPrefsCodable where Value: RawRepresentable, Value.RawValue == StorageValue {
    public func getDefaultedValue(forKey key: String, in storage: PrefsStorage) -> Value {
        guard let rawRepValue = getValue(forKey: key, in: storage)
        else { return defaultValue }
        
        return rawRepValue
    }
}
