//
//  BasicPrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A basic prefs key that stores a standard value.
public protocol BasicPrefKey: PrefKey
where Value == StorageValue { }
