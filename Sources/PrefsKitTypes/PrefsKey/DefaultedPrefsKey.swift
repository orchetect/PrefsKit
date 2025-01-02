//
//  DefaultedPrefsKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public protocol DefaultedPrefsKey: PrefsKey {
    var defaultValue: Value { get }
}

extension DefaultedPrefsKey {
    public func decodeDefaulted(_ storageValue: StorageValue?) -> Value {
        decode(storageValue) ?? defaultValue
    }
}
