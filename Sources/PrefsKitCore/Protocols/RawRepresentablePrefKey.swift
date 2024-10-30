//
//  RawRepresentablePrefKey.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

public protocol RawRepresentablePrefKey<T, StorageValue>: PrefKey where T: RawRepresentable, T.RawValue == StorageValue {
    associatedtype T
}
