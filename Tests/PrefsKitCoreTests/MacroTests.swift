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

#if canImport(PrefsKitMacros)

@testable import PrefsKitMacros

final class MacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "Pref": PrefMacro.self,
        "Prefs": PrefsMacro.self
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
                    __PrefValue_foo = __PrefKey_foo.getValue(in: storage)
                    return __PrefValue_foo
                }
                set {
                    withMutation(keyPath: \\.foo) {
                        __PrefKey_foo.setValue(to: newValue, in: storage)
                        __PrefValue_foo = newValue
                    }
                }
                _modify {
                    access(keyPath: \\.foo)
                    _$observationRegistrar.willSet(self, keyPath: \\.foo)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.foo)
                    }
                    yield &__PrefValue_foo
                    __PrefKey_foo.setValue(to: __PrefValue_foo, in: storage)
                }
            }
            
            private let __PrefKey_foo = PrefsKitCore.AnyAtomicPrefKey<Int>(key: "someInt")
            
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
                    __PrefValue_bar = __PrefKey_bar.getDefaultedValue(in: storage)
                    return __PrefValue_bar
                }
                set {
                    withMutation(keyPath: \\.bar) {
                        __PrefKey_bar.setValue(to: newValue, in: storage)
                        __PrefValue_bar = newValue
                    }
                }
                _modify {
                    access(keyPath: \\.bar)
                    _$observationRegistrar.willSet(self, keyPath: \\.bar)
                    defer {
                        _$observationRegistrar.didSet(self, keyPath: \\.bar)
                    }
                    yield &__PrefValue_bar
                    __PrefKey_bar.setValue(to: __PrefValue_bar, in: storage)
                }
            }
            
            private let __PrefKey_bar = PrefsKitCore.AnyDefaultedAtomicPrefKey<String>(key: KeyName.bar, defaultValue: "baz")
            
            private var __PrefValue_bar: String = "baz"
            """,
            macros: testMacros
        )
    }
}

#endif
