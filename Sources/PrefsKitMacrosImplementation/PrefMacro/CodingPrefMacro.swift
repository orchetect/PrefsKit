//
//  CodingPrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct CodingPrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyPrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedPrefsKey"
    public static let hasCustomCoding: Bool = true
    public static let hasInlineCoding: Bool = false
}
