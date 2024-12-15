//
//  JSONCodablePrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public struct JSONCodablePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyJSONDataCodablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedJSONDataCodablePrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}
