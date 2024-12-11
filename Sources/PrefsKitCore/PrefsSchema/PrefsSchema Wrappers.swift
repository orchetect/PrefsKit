//
//  PrefsSchema Wrappers.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Observation

// /// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
// @_documentation(visibility: internal)
// @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
// @Observable public final class ObservablePref<Key: PrefKey> where Key.Value: Equatable {
//     let key: Key
//     private var cachedValue: Key.Value?
// 
//     @ObservationIgnored
//     let storage: PrefsStorage
//     let isCacheEnabled: Bool
// 
//     public init(key: Key, storage: PrefsStorage, isCacheEnabled: Bool) {
//         self.key = key
//         self.storage = storage
//         self.isCacheEnabled = isCacheEnabled
//         cachedValue = key.getValue(in: storage)
//     }
// 
//     /// Returns value.
//     public var value: Key.Value? {
//         get {
//             if !isCacheEnabled {
//                 let v = key.getValue(in: storage)
//                 if cachedValue != v { cachedValue = v }
//             }
//             return cachedValue
//         }
//         set {
//             key.setValue(to: newValue, in: storage)
//             cachedValue = newValue
//         }
//     }
// }
// 
// /// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
// @_documentation(visibility: internal)
// @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
// @Observable public final class ObservableDefaultedPref<Key: DefaultedPrefsCodable> where Key.Value: Equatable {
//     let key: Key
//     private var cachedValue: Key.Value
// 
//     @ObservationIgnored
//     let storage: PrefsStorage
//     let isCacheEnabled: Bool
// 
//     public init(key: Key, storage: PrefsStorage, isCacheEnabled: Bool) {
//         self.key = key
//         self.storage = storage
//         self.isCacheEnabled = isCacheEnabled
//         cachedValue = key.getDefaultedValue(in: storage)
//     }
// 
//     /// Returns value, or default value if key is missing.
//     public var value: Key.Value {
//         get {
//             if !isCacheEnabled {
//                 let v = key.getDefaultedValue(in: storage)
//                 if cachedValue != v { cachedValue = v }
//             }
//             return cachedValue
//         }
//         set {
//             key.setValue(to: newValue, in: storage)
//             cachedValue = newValue
//         }
//     }
// }

/// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class ObservablePref<Coding: PrefsCodable> where Coding.Value: Equatable {
    let key: String
    let coding: Coding
    private var cachedValue: Coding.Value?
    
    @ObservationIgnored
    let storage: () -> PrefsStorage?
    let isCacheEnabled: () -> Bool?
    
    public init(
        key: String,
        coding: Coding,
        storage: @escaping () -> PrefsStorage?,
        isCacheEnabled: @escaping () -> Bool?
    ) {
        self.key = key
        self.coding = coding
        self.storage = storage
        self.isCacheEnabled = isCacheEnabled
        if let storage = storage() {
            cachedValue = coding.getValue(forKey: key, in: storage)
        }
    }
    
    /// Returns value.
    public var value: Coding.Value? {
        get {
            if let isCacheEnabled = isCacheEnabled(),
               !isCacheEnabled,
               let storage = storage()
            {
                let v = coding.getValue(forKey: key, in: storage)
                if cachedValue != v { cachedValue = v }
            }
            return cachedValue
        }
        set {
            if let storage = storage() {
                coding.setValue(forKey: key, to: newValue, in: storage)
            }
            cachedValue = newValue
        }
    }
}

/// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class ObservableDefaultedPref<Coding: DefaultedPrefsCodable> where Coding.Value: Equatable {
    let key: String
    let coding: Coding
    private var cachedValue: Coding.Value
    
    @ObservationIgnored
    let storage: () -> PrefsStorage?
    let isCacheEnabled: () -> Bool?
    
    public init(
        key: String,
        coding: Coding,
        storage: @escaping () -> PrefsStorage?,
        isCacheEnabled: @escaping () -> Bool?
    ) {
        self.key = key
        self.coding = coding
        self.storage = storage
        self.isCacheEnabled = isCacheEnabled
        if let storage = storage() {
            cachedValue = coding.getDefaultedValue(forKey: key, in: storage)
        } else {
            cachedValue = coding.defaultValue
        }
    }
    
    /// Returns value, or default value if key is missing.
    public var value: Coding.Value {
        get {
            if let isCacheEnabled = isCacheEnabled(),
               !isCacheEnabled,
               let storage = storage()
            {
                let v = coding.getDefaultedValue(forKey: key, in: storage)
                if cachedValue != v { cachedValue = v }
            }
            return cachedValue
        }
        set {
            if let storage = storage() {
                coding.setValue(forKey: key, to: newValue, in: storage)
            }
            cachedValue = newValue
        }
    }
}
