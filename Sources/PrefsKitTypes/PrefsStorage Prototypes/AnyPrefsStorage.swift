//
//  AnyPrefsStorage.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
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
    
    public func setStorageValue<StorageValue: PrefsStorageValue>(forKey key: String, to value: StorageValue?) {
        wrapped.setStorageValue(forKey: key, to: value)
    }
    
    // MARK: - Get
    
    public func storageValue(forKey key: String) -> Int? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> String? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Bool? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Double? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Float? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> Data? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [Element]? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue<Element: PrefsStorageValue>(forKey key: String) -> [String: Element]? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> [Any]? {
        wrapped.storageValue(forKey: key)
    }
    
    public func storageValue(forKey key: String) -> [String: Any]? {
        wrapped.storageValue(forKey: key)
    }
}

extension AnyPrefsStorage: _PrefsStorage {
    @_disfavoredOverload
    package func setStorageValue(forKey key: String, to value: Any) {
        guard let wrapped = wrapped as? _PrefsStorage else {
            assertionFailure("Could not cast \(type(of: wrapped)) as _PrefsStorage. Failed to set storage value for key \"\(key)\".")
            return
        }
        wrapped.setStorageValue(forKey: key, to: value)
    }
}