//
//  PrefStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol adopted by value types that are valid for storage in UserDefaults.
public protocol PrefStorageValue where Self: Sendable { }

extension Int: PrefStorageValue { }
extension String: PrefStorageValue { }
extension Bool: PrefStorageValue { }
extension Double: PrefStorageValue { }
extension Float: PrefStorageValue { }
extension Data: PrefStorageValue { }
extension [any PrefStorageValue]: PrefStorageValue { }
extension [String: any PrefStorageValue]: PrefStorageValue { }
