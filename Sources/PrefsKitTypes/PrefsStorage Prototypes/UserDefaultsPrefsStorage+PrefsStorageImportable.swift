//
//  UserDefaultsPrefsStorage+PrefsStorageImportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: _PrefsStorageImportable {
    package func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageImportBehavior) throws {
        switch behavior {
        case .replacingStorage:
            suite.removeAllKeys()
            suite.merge(contents)
        case .mergingWithStorage:
            suite.merge(contents)
        }
    }
    
    @_disfavoredOverload
    package func load(unsafe contents: [String: Any], by behavior: PrefsStorageImportBehavior) throws {
        switch behavior {
        case .replacingStorage:
            suite.removeAllKeys()
            suite.merge(contents)
        case .mergingWithStorage:
            suite.merge(contents)
        }
    }
}
