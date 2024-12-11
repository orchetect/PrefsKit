//
//  AtomicDefaultedPrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A prefs key that stores a standard atomic value type and provides a default value.
public protocol AtomicDefaultedPrefsCodable: DefaultedPrefsCodable where Value == StorageValue { }
