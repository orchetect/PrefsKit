//
//  DictionaryPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStorageImportable {
    @discardableResult
    public func load(from contents: [String: any PrefsStorageValue], by behavior: PrefsStorageUpdateStrategy) throws -> Set<String> {
        switch behavior {
        case .replacingStorage:
            storage = contents
            return Set(contents.keys)
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
            return Set(contents.keys)
        }
    }
    
    @discardableResult
    public func load(unsafe contents: [String: Any], by behavior: PrefsStorageUpdateStrategy) throws -> Set<String> {
        switch behavior {
        case .replacingStorage:
            storage = contents
            return Set(contents.keys)
        case .mergingWithStorage:
            storage.merge(contents) { old, new in new }
            return Set(contents.keys)
        }
    }
}
