//
//  AnyPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box containing an instance of a concrete class conforming to ``PrefsStorage``.
public final class AnyPrefsStorage: PrefsStorage {
    public let wrapped: any PrefsStorage
    
    public init(_ wrapped: any PrefsStorage) {
        self.wrapped = wrapped
    }
}

extension AnyPrefsStorage {
    // MARK: - Set
    
    public func setValue<Value: PrefStorageValue>(forKey key: String, to value: Value?) {
        wrapped.setValue(forKey: key, to: value)
    }
    
    // MARK: - Get
    
    public func value(forKey key: String) -> Int? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> String? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> Bool? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> Double? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> Float? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> Data? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> [any PrefStorageValue]? {
        wrapped.value(forKey: key)
    }
    
    public func value(forKey key: String) -> [String: any PrefStorageValue]? {
        wrapped.value(forKey: key)
    }
}
