//
//  UserDefaults Extensions.swift
//  PrefsKit
//
//  Created by Steffan Andrews on 2024-10-24.
//

import Foundation

extension UserDefaults {
    func getValue(forKey key: String) -> Int? {
        integerOptional(forKey: key)
    }
    
    func getValue(forKey key: String) -> String? {
        string(forKey: key)
    }
    
    func getValue(forKey key: String) -> Bool? {
        boolOptional(forKey: key)
    }
    
    func getValue(forKey key: String) -> Double? {
        doubleOptional(forKey: key)
    }
    
    func getValue(forKey key: String) -> Float? {
        floatOptional(forKey: key)
    }
    
    func getValue(forKey key: String) -> Data? {
        data(forKey: key)
    }
    
    func getValue(forKey key: String) -> [Any]?  {
        array(forKey: key)
    }
    
    func getValue(forKey key: String) -> [String: Any]? {
        dictionary(forKey: key)
    }
}
