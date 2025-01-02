//
//  AtomicPrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// A basic prefs value coding protocol for storing a standard atomic value type.
public protocol AtomicPrefsCodable: PrefsCodable where Value == StorageValue { }
