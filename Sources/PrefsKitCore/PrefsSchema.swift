//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public protocol PrefsSchema {
    associatedtype Storage: PrefsStorage
    var storage: Storage { get }
}

extension PrefsSchema {
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    @_disfavoredOverload
    public func pref<Key: PrefKey>(_ key: Key) -> PrefAndStorage<Key> {
        PrefAndStorage(key: key, storage: storage)
    }
    
    /// Wrap a pref key instance. Used in ``PrefsSchema``.
    public func pref<Key: DefaultedPrefKey>(_ key: Key) -> DefaultedPrefAndStorage<Key> {
        DefaultedPrefAndStorage(key: key, storage: storage)
    }
}

/// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
@_documentation(visibility: internal)
public struct PrefAndStorage<Key: PrefKey> {
    let key: Key
    let storage: PrefsStorage
    
    init(key: Key, storage: PrefsStorage) {
        self.key = key
        self.storage = storage
    }
    
    /// Returns value.
    public var value: Key.Value? {
        get { key.getValue(in: storage) }
        set { key.setValue(to: newValue, in: storage) }
    }
}

/// Wrapper for pref key and storage reference. Used in ``PrefsSchema``.
@_documentation(visibility: internal)
public struct DefaultedPrefAndStorage<Key: DefaultedPrefKey> {
    let key: Key
    let storage: PrefsStorage
    
    init(key: Key, storage: PrefsStorage) {
        self.key = key
        self.storage = storage
    }
    
    /// Returns value, or default value if key is missing.
    public var value: Key.Value {
        get { key.getDefaultedValue(in: storage) }
        set { key.setValue(to: newValue, in: storage) }
    }
}
