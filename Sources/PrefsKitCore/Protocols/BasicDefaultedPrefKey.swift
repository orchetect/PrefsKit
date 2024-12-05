//
//  BasicDefaultedPrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-12-04.
//

/// A basic prefs key that stores a standard value and provides a default value.
public protocol BasicDefaultedPrefKey: DefaultedPrefKey where Value == StorageValue { }
