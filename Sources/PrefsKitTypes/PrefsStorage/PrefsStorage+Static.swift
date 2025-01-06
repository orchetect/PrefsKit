//
//  PrefsStorage+Static.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
