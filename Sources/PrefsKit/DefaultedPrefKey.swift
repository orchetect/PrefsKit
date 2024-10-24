//
//  DefaultedPrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

public protocol DefaultedPrefKey: PrefKey {
    /// Default value to return if no UserDefaults key exists or its value is mismatched.
    var defaultValue: Value { get }
    
    /// Returns the current value stored in UserDefaults.
    /// Returns the ``defaultValue`` if no UserDefaults key exists or its value is mismatched.
    func getValueDefaulted() -> Value
}

extension DefaultedPrefKey {
    public func getValueDefaulted() -> Value {
        getValue() ?? defaultValue
    }
}
