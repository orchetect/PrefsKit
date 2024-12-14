//
//  PrefsStorage+Static.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// We could offer `.any()` but it's a little confusing.
// Just let users construct an instance of `AnyPrefsStorage` when they want to.
//
// extension PrefsStorage where Self == AnyPrefsStorage {
//     /// Type-erased box containing an instance of a concrete class conforming to ``PrefsStorage``.
//     public static func any(_ storage: any PrefsStorage) -> AnyPrefsStorage {
//         AnyPrefsStorage(storage)
//     }
// }

extension PrefsStorage where Self == DictionaryPrefsStorage {
    /// Dictionary prefs storage.
    public static var dictionary: DictionaryPrefsStorage {
        DictionaryPrefsStorage()
    }
    
    /// Dictionary prefs storage with initial root content.
    public static func dictionary(root: [String: any PrefsStorageValue]) -> DictionaryPrefsStorage {
        DictionaryPrefsStorage(root: root)
    }
}

extension PrefsStorage where Self == UserDefaultsPrefsStorage {
    /// Standard `UserDefaults` suite prefs storage.
    public static var userDefaults: UserDefaultsPrefsStorage {
        UserDefaultsPrefsStorage()
    }
    
    /// Custom `UserDefaults` suite prefs storage.
    public static func userDefaults(suite: UserDefaults) -> UserDefaultsPrefsStorage {
        UserDefaultsPrefsStorage(suite: suite)
    }
}
