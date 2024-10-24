//
//  PrefStorageValue.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
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
extension [Any]: PrefStorageValue { }
extension [String: Any]: PrefStorageValue { }
