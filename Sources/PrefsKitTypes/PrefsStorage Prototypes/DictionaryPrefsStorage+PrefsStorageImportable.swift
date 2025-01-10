//
//  DictionaryPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStorageImportable {
    public func load(from contents: [String: any PrefsStorageValue], by behavior: PrefsStorageUpdateStrategy) throws {
        switch behavior {
        case .replacingStorage:
            storage = contents
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
        }
    }
    
    public func load(unsafe contents: [String: Any], by behavior: PrefsStorageUpdateStrategy) throws {
        switch behavior {
        case .replacingStorage:
            storage = contents
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
        }
    }
}
