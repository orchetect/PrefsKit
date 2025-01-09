//
//  UserDefaultsPrefsStorage+PrefsStorageExportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaultsPrefsStorage: PrefsStorageExportable {
    public func dictionaryRepresentation() throws -> [String : Any] {
        // UserDefaults suite includes all search lists when requesting its `dictionaryRepresentation()`,
        // which means a lot more keys than expected may be included.
        suite.dictionaryRepresentation()
    }
}
