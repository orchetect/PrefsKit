//
//  Test PList Content.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitTypes

enum TestPList {
    enum Basic {
        static let xmlString: String = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
                <key>key1</key>
                <string>string</string>
                <key>key2</key>
                <integer>123</integer>
                <key>key3</key>
                <true/>
                <key>key4</key>
                <data>
                AQI=
                </data>
                <key>key5</key>
                <date>2025-01-07T05:32:03Z</date>
                <key>key6</key>
                <array>
                    <string>string1</string>
                    <string>string2</string>
                </array>
                <key>key7</key>
                <array>
                    <string>string</string>
                    <integer>456</integer>
                    <false/>
                </array>
                <key>key8</key>
                <array>
                    <array>
                        <string>string</string>
                    </array>
                    <dict>
                        <key>keyA</key>
                        <string>stringA</string>
                        <key>keyB</key>
                        <integer>234</integer>
                    </dict>
                </array>
                <key>key9</key>
                <dict>
                    <key>keyA</key>
                    <string>stringA</string>
                    <key>keyB</key>
                    <string>stringB</string>
                </dict>
                <key>key10</key>
                <dict>
                    <key>keyA</key>
                    <string>string</string>
                    <key>keyB</key>
                    <integer>789</integer>
                    <key>keyC</key>
                    <data>
                    AwQ=
                    </data>
                </dict>
                <key>key11</key>
                <dict>
                    <key>keyA</key>
                    <array>
                        <string>string</string>
                    </array>
                    <key>keyB</key>
                    <dict>
                        <key>keyI</key>
                        <string>string</string>
                        <key>keyII</key>
                        <integer>567</integer>
                    </dict>
                </dict>
            </dict>
            </plist>
            """
        
        enum Root {
            enum Key1 {
                static let key: String = "key1"
                static let value: String = "string"
            }
            
            enum Key2 {
                static let key: String = "key2"
                static let value: Int = 123
            }
            
            enum Key3 {
                static let key: String = "key3"
                static let value: Bool = true
            }
            
            enum Key4 {
                static let key: String = "key4"
                static let value: Data = Data([0x01, 0x02])
            }
            
            enum Key5 {
                static let key: String = "key5"
                static let value: Date = try! Date("2025-01-07T05:32:03Z", strategy: .iso8601)
            }
            
            enum Key6 {
                static let key: String = "key6"
                static let value: [String] = ["string1", "string2"]
            }
            
            enum Key7 {
                static let key: String = "key7"
                static let value: [any PrefsStorageValue] = [valueIndex0, valueIndex1, valueIndex2]
                static let valueIndex0: String = "string"
                static let valueIndex1: Int = 456
                static let valueIndex2: Bool = false
            }
            
            enum Key8 {
                static let key: String = "key8"
                static var value: [Any] { [valueIndex0, valueIndex1] }
                static var valueIndex0: [Any] { [valueIndex0Index0] }
                static let valueIndex0Index0: String = "string"
                static var valueIndex1: [String: Any] { [KeyA.key: KeyA.value, KeyB.key: KeyB.value] }
                enum KeyA {
                    static let key: String = "keyA"
                    static let value: String = "stringA"
                }
                enum KeyB {
                    static let key: String = "keyB"
                    static let value: Int = 234
                }
            }
            
            enum Key9 {
                static let key: String = "key9"
                static let value: [String: String] = [KeyA.key: KeyA.value, KeyB.key: KeyB.value]
                enum KeyA {
                    static let key: String = "keyA"
                    static let value: String = "stringA"
                }
                enum KeyB {
                    static let key: String = "keyB"
                    static let value: String = "stringB"
                }
            }
            
            enum Key10 {
                static let key: String = "key10"
                static let value: [String: any PrefsStorageValue] = [
                    KeyA.key: KeyA.value,
                    KeyB.key: KeyB.value,
                    KeyC.key: KeyC.value
                ]
                enum KeyA {
                    static let key: String = "keyA"
                    static let value: String = "string"
                }
                enum KeyB {
                    static let key: String = "keyB"
                    static let value: Int = 789
                }
                enum KeyC {
                    static let key: String = "keyC"
                    static let value: Data = Data([0x03, 0x04])
                }
            }
            
            enum Key11 {
                static let key: String = "key11"
                static var value: [String: Any] {
                    [
                        KeyA.key: KeyA.value,
                        KeyB.key: KeyB.value
                    ]
                }
                enum KeyA {
                    static let key: String = "keyA"
                    static let value: [String] = ["string"]
                }
                enum KeyB {
                    static let key: String = "keyB"
                    static var value: [String: Any] { [KeyI.key: KeyI.value, KeyII.key: KeyII.value] }
                    enum KeyI {
                        static let key: String = "keyI"
                        static let value: String = "string"
                    }
                    enum KeyII {
                        static let key: String = "keyII"
                        static let value: Int = 567
                    }
                }
            }
        }
    }
}
