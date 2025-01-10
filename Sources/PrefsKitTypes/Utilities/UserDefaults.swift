//
//  UserDefaults.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension UserDefaults {
    func removeAllKeys() {
        let keys = dictionaryRepresentation().keys
        for key in keys {
            removeObject(forKey: key)
        }
    }
    
    func merge(_ contents: [String: Any]) {
        for element in contents {
            set(element.value, forKey: element.key)
        }
    }
}
