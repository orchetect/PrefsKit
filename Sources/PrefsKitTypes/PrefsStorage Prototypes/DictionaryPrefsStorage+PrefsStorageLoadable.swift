//
//  DictionaryPrefsStorage+PrefsStorageLoadable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: _PrefsStorageLoadable {
    package func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageLoadBehavior) throws {
        switch behavior {
        case .replacingStorage:
            storage = contents
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
        }
    }
    
    @_disfavoredOverload
    package func load(raw contents: [String: Any], by behavior: PrefsStorageLoadBehavior) throws {
        switch behavior {
        case .replacingStorage:
            storage = contents
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
        }
    }
}
