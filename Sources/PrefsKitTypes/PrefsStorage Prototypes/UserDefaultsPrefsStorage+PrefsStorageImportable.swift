//
//  UserDefaultsPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: PrefsStorageImportable {
    public func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageUpdateStrategy) throws {
        switch behavior {
        case .replacingStorage:
            suite.removeAllKeys()
            suite.merge(contents)
        case .mergingWithStorage:
            suite.merge(contents)
        }
    }
    
    public func load(unsafe contents: [String: Any], by behavior: PrefsStorageUpdateStrategy) throws {
        switch behavior {
        case .replacingStorage:
            suite.removeAllKeys()
            suite.merge(contents)
        case .mergingWithStorage:
            suite.merge(contents)
        }
    }
}
