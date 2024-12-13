//
//  RawRepresentablePrefsCodable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public protocol RawRepresentablePrefsCodable: PrefsCodable where Value: RawRepresentable, Value.RawValue == StorageValue { }
