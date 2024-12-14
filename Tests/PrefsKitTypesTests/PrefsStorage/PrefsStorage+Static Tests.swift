//
//  PrefsStorage+Static Tests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitTypes
import Testing

@Suite struct PrefsStorageStaticTests {
    /// No logic testing, just ensure compiler is happy with our syntax sugar.
    @Test func varSyntax() {
        let _: PrefsStorage = AnyPrefsStorage(.dictionary)
        let _: PrefsStorage = AnyPrefsStorage(.dictionary(root: [:]))
        let _: PrefsStorage = AnyPrefsStorage(.userDefaults)
        let _: PrefsStorage = AnyPrefsStorage(.userDefaults(suite: .standard))
        
        let _: PrefsStorage = DictionaryPrefsStorage()
        let _: PrefsStorage = UserDefaultsPrefsStorage()
        
        let _: PrefsStorage = .dictionary
        let _: PrefsStorage = .dictionary(root: [:])
        let _: PrefsStorage = .userDefaults
        let _: PrefsStorage = .userDefaults(suite: .standard)
    }
    
    /// No logic testing, just ensure compiler is happy with our syntax sugar.
    @Test func anySyntax() {
        func foo(_ storage: any PrefsStorage) { }
        
        foo(AnyPrefsStorage(.dictionary))
        foo(AnyPrefsStorage(.dictionary(root: [:])))
        foo(AnyPrefsStorage(.userDefaults))
        foo(AnyPrefsStorage(.userDefaults(suite: .standard)))
        
        foo(DictionaryPrefsStorage())
        foo(UserDefaultsPrefsStorage())
        
        foo(.dictionary)
        foo(.dictionary(root: [:]))
        foo(.userDefaults)
        foo(.userDefaults(suite: .standard))
    }
    
    /// No logic testing, just ensure compiler is happy with our syntax sugar.
    @Test func someSyntax() {
        func foo<S>(_ storage: S) where S: PrefsStorage { }
        
        foo(AnyPrefsStorage(.dictionary))
        foo(AnyPrefsStorage(.dictionary(root: [:])))
        foo(AnyPrefsStorage(.userDefaults))
        foo(AnyPrefsStorage(.userDefaults(suite: .standard)))
        
        foo(DictionaryPrefsStorage())
        foo(UserDefaultsPrefsStorage())
        
        // doesn't work. huh?
        foo(.dictionary)
        foo(.dictionary(root: [:]))
        foo(.userDefaults)
        foo(.userDefaults(suite: .standard))
    }
}
