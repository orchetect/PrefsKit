//
//  AtomicPrefsCoding.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A basic prefs value coding strategy that stores a standard atomic value type directly without any additional
/// processing.
public struct AtomicPrefsCoding<Value>: AtomicPrefsCodable where Value: PrefsStorageValue {
    public typealias Value = Value
    
    public init() { }
}
