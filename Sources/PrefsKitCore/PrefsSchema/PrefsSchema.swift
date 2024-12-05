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
