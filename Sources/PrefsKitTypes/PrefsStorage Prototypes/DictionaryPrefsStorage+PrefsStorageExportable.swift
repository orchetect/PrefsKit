//
//  DictionaryPrefsStorage+PrefsStorageExportable.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension DictionaryPrefsStorage: PrefsStorageExportable {
    public func dictionaryRepresentation() throws -> [String : Any] {
        storage
    }
}
