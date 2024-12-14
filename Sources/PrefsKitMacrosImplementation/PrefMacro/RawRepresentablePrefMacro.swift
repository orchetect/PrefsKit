//
//  RawRepresentablePrefMacro.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public struct RawRepresentablePrefMacro: PrefMacro {
    public static let keyStructName: String = "AnyRawRepresentablePrefsKey"
    public static let defaultedKeyStructName: String = "AnyDefaultedRawRepresentablePrefsKey"
    public static let hasCustomCoding: Bool = false
}
