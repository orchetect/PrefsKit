//
//  JSONDataCodablePrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

public struct JSONDataCodablePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyJSONDataCodablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedJSONDataCodablePrefsKey"
    public static let hasCustomCoding: Bool = false
    public static let hasInlineCoding: Bool = false
}
