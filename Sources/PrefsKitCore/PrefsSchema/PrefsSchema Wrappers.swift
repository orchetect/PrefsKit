//
//  PrefsSchema Wrappers.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Observation

/// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class ObservablePref<Key: PrefKey> where Key.Value: Equatable {
    let key: Key
    private var cachedValue: Key.Value?
    
    @ObservationIgnored
    let storage: PrefsStorage
    
    public init(key: Key, storage: PrefsStorage) {
        self.key = key
        self.storage = storage
        cachedValue = key.getValue(in: storage)
    }
    
    /// Returns value.
    public var value: Key.Value? {
        get {
            // let v = key.getValue(in: storage)
            // if cachedValue != v { cachedValue = v }
            return cachedValue
        }
        set {
            key.setValue(to: newValue, in: storage)
            cachedValue = newValue
        }
    }
}

/// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class ObservableDefaultedPref<Key: DefaultedPrefKey> where Key.Value: Equatable {
    let key: Key
    private var cachedValue: Key.Value
    
    @ObservationIgnored
    let storage: PrefsStorage
    
    public init(key: Key, storage: PrefsStorage) {
        self.key = key
        self.storage = storage
        cachedValue = key.getDefaultedValue(in: storage)
    }
    
    /// Returns value, or default value if key is missing.
    public var value: Key.Value {
        get {
            // let v = key.getDefaultedValue(in: storage)
            // if cachedValue != v { cachedValue = v }
            return cachedValue
        }
        set {
            key.setValue(to: newValue, in: storage)
            cachedValue = newValue
        }
    }
}
