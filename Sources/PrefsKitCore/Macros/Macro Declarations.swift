//
//  Macro Declarations.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

@attached(member, names: named(_$observationRegistrar))
@attached(extension, names: named(access), named(withMutation), conformances: Observable)
public macro Prefs() = #externalMacro(module: "PrefsKitMacros", type: "PrefsMacro")

@attached(accessor, names: named(get), named(set), named(_modify))
@attached(peer, names: /*arbitrary*/ prefixed(__PrefKey_), prefixed(__PrefValue_))
public macro Pref(key: String) = #externalMacro(module: "PrefsKitMacros", type: "PrefMacro")
