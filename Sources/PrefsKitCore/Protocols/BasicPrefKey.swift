//
//  BasicPrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-12-04.
//

/// A basic prefs key that stores a standard value.
public protocol BasicPrefKey: PrefKey where Value == StorageValue { }
