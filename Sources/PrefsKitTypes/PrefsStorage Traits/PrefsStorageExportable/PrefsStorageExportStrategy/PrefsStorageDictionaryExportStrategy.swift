//
//  PrefsStorageDictionaryExportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public protocol PrefsStorageDictionaryExportStrategy: PrefsStorageExportStrategy {
    // does not implement any additional requirements, just mutates the dictionary if needed
    // by way of the ``PrefsStorageExportStrategy`` prepare method
}
