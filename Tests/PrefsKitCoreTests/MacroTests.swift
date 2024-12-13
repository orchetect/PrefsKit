//
//  MacroTests.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

import PrefsKitCore
import XCTest

// MARK: - Macro Implementation Testing

#if canImport(PrefsKitMacrosImplementation)

@testable import PrefsKitMacrosImplementation

final class MacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Prefs": PrefsMacro.self,
        "Pref": AtomicPrefMacro.self,
        "RawRepresentablePref": RawRepresentablePrefMacro.self
    ]
    
    func testPrefsMacro() {
        assertMacroExpansion(
            """
            @Prefs final class Foo {
                var foo: Int?
            }
            """,
            expandedSource: """
            final class Foo {
                var foo: Int?
            
                @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()
            }
            
            extension Foo: Observable {
                internal nonisolated func access<Member>(
                    keyPath: KeyPath<Foo, Member>
                ) {
                    _$observationRegistrar.access(self, keyPath: keyPath)
                }
            
                internal nonisolated func withMutation<Member, MutationResult>(
                    keyPath: KeyPath<Foo, Member>,
                    _ mutation: () throws -> MutationResult
                ) rethrows -> MutationResult {
                    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testPrefMacro() {
        assertMacroExpansion(
            """
            @Pref(key: "someInt") var foo: Int?
            """,
            expandedSource: """
            var foo: Int? {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.foo)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_foo == nil {
                            __PrefValue_foo = storage.value(forKey: __PrefCoding_foo)
                        }
                        return __PrefValue_foo
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_foo)
                    }
                }
                set {
                    withMutation(keyPath: \\.foo) {
                        storage.setValue(forKey: __PrefCoding_foo, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_foo = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.foo)
                    _$observationRegistrar.willSet(self, keyPath: \\.foo)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.foo)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_foo == nil {
                            __PrefValue_foo = storage.value(forKey: __PrefCoding_foo)
                        }
                        yield &__PrefValue_foo
                        storage.setValue(forKey: __PrefCoding_foo, to: __PrefValue_foo)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_foo)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_foo, to: val)
                    }
                }
            }
            
            private let __PrefCoding_foo = PrefsKitTypes.AnyAtomicPrefsKey<Int>(key: "someInt")
            
            private var __PrefValue_foo: Int?
            """,
            macros: testMacros
        )
    }
    
    func testPrefMacroB() {
        assertMacroExpansion(
            """
            @Pref(key: KeyName.bar) var bar: String = "baz"
            """,
            expandedSource: """
            var bar: String {
                get {
                    _$observationRegistrar.access(self, keyPath: \\.bar)
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar)
                        }
                        return __PrefValue_bar ?? __PrefCoding_bar.defaultValue
                    case .storageOnly:
                        return storage.value(forKey: __PrefCoding_bar)
                    }
                }
                set {
                    withMutation(keyPath: \\.bar) {
                        storage.setValue(forKey: __PrefCoding_bar, to: newValue)
                        if storageMode == .cachedReadStorageWrite {
                            __PrefValue_bar = newValue
                        }
                    }
                }
                _modify {
                    access(keyPath: \\.bar)
                    _$observationRegistrar.willSet(self, keyPath: \\.bar)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.bar)
                    }
                    switch storageMode {
                    case .cachedReadStorageWrite:
                        if __PrefValue_bar == nil {
                            __PrefValue_bar = storage.value(forKey: __PrefCoding_bar)
                        }
                        yield &__PrefValue_bar!
                        storage.setValue(forKey: __PrefCoding_bar, to: __PrefValue_bar)
                    case .storageOnly:
                        var val = storage.value(forKey: __PrefCoding_bar)
                        yield &val
                        storage.setValue(forKey: __PrefCoding_bar, to: val)
                    }
                }
            }
            
            private let __PrefCoding_bar = PrefsKitTypes.AnyDefaultedAtomicPrefsKey<String>(key: KeyName.bar, defaultValue: "baz")
            
            private var __PrefValue_bar: String?
            """,
            macros: testMacros
        )
    }
}

#endif
