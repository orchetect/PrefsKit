//
//  PrefStorageValue.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol adopted by value types that are valid for storage in UserDefaults.
public protocol PrefStorageValue { }

extension Int: PrefStorageValue { }
extension String: PrefStorageValue { }
extension Bool: PrefStorageValue { }
extension Double: PrefStorageValue { }
extension Float: PrefStorageValue { }
extension Data: PrefStorageValue { }
extension [PrefStorageValue]: PrefStorageValue { }
extension [String: PrefStorageValue]: PrefStorageValue { }
