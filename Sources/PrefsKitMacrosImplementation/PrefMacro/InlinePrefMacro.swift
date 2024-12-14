//
//  InlinePrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public struct InlinePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyJSONCodablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedJSONCodablePrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = true
}
