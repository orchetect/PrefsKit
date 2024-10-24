//
//  RawRepresentableDefaultedPrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

public protocol RawRepresentableDefaultedPrefKey<T, StorageValue>: RawRepresentablePrefKey where T: RawRepresentable, T.RawValue == StorageValue {
    associatedtype T
    
    /// Default value to return if no UserDefaults key exists or its value is mismatched.
    var defaultValue: T { get }
    
    /// Returns the current value stored in UserDefaults.
    /// Returns the ``defaultValue`` if no UserDefaults key exists or its value is mismatched.
    func getValueDefaulted() -> T
}

extension RawRepresentableDefaultedPrefKey {
    public func getValueDefaulted() -> T {
        guard let rawValue = getValue(),
              let value = T(rawValue: rawValue)
        else { return defaultValue }
        return value
    }
}
