//
//  JSONStringCodablePrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public struct JSONStringCodablePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyJSONStringCodablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedJSONStringCodablePrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}
