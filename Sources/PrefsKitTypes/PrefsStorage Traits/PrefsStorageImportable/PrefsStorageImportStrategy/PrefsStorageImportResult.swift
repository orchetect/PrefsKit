//
//  PrefsStorageImportResult.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public enum PrefsStorageImportResult {
    case atomic(any PrefsStorageValue)
    case unsafe(Any)
}
