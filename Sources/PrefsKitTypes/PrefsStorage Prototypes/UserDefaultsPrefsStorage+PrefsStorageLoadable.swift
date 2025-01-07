//
//  UserDefaultsPrefsStorage+PrefsStorageLoadable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: _PrefsStorageLoadable {
    package func load(raw contents: [String: any PrefsStorageValue], by behavior: PrefsStorageLoadBehavior) throws {
        switch behavior {
        case .replacingStorage:
            suite.removeAllKeys()
            suite.merge(contents)
        case .mergingWithStorage:
            suite.merge(contents)
        }
    }
    
    @_disfavoredOverload
    package func load(raw contents: [String: Any], by behavior: PrefsStorageLoadBehavior) throws {
        switch behavior {
        case .replacingStorage:
            suite.removeAllKeys()
            suite.merge(contents)
        case .mergingWithStorage:
            suite.merge(contents)
        }
    }
}
