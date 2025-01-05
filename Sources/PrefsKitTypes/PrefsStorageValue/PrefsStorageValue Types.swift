//
//  PrefsStorageValue Types.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Atomic Types

extension AnyPrefsStorageValue: PrefsStorageValue { }

extension Int: PrefsStorageValue { }

extension String: PrefsStorageValue { }

extension Bool: PrefsStorageValue { }

extension Double: PrefsStorageValue { }

extension Float: PrefsStorageValue { }

extension Data: PrefsStorageValue { }

extension Array: PrefsStorageValue where Element: PrefsStorageValue { }

extension Dictionary: PrefsStorageValue where Key == String, Value: PrefsStorageValue { }

// MARK: - Additional Types

extension NSNumber: PrefsStorageValue { }
