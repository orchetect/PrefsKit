//
//  BasicDefaultedPrefKey.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A basic prefs key that stores a standard value and provides a default value.
public protocol BasicDefaultedPrefKey: DefaultedPrefKey
where Value == StorageValue { }
