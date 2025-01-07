//
//  Test PList Content.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import PrefsKitTypes
import Testing

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
            static var dictionary: [String: Any] {
                [
                    Key1.key: Key1.value,
                    Key2.key: Key2.value,
                    Key3.key: Key3.value,
                    Key4.key: Key4.value,
                    Key5.key: Key5.value,
                    Key6.key: Key6.value,
                    Key7.key: Key7.value,
                    Key8.key: Key8.value,
                    Key9.key: Key9.value,
                    Key10.key: Key10.value,
                    Key11.key: Key11.value
                ]
            }
            
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
                static let value: Date = ISO8601DateFormatter().date(from: "2025-01-07T05:32:03Z")!
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
        
        static func checkContent(in storage: any PrefsStorage) async throws {
            typealias Key1 = TestPList.Basic.Root.Key1
            typealias Key2 = TestPList.Basic.Root.Key2
            typealias Key3 = TestPList.Basic.Root.Key3
            typealias Key4 = TestPList.Basic.Root.Key4
            typealias Key5 = TestPList.Basic.Root.Key5
            typealias Key6 = TestPList.Basic.Root.Key6
            typealias Key7 = TestPList.Basic.Root.Key7
            typealias Key8 = TestPList.Basic.Root.Key8
            typealias Key9 = TestPList.Basic.Root.Key9
            typealias Key10 = TestPList.Basic.Root.Key10
            typealias Key11 = TestPList.Basic.Root.Key11
            
            #expect(storage.storageValue(forKey: Key1.key) == Key1.value)
            
            #expect(storage.storageValue(forKey: Key2.key) == Key2.value)
            
            #expect(storage.storageValue(forKey: Key3.key) == Key3.value)
            
            #expect(storage.storageValue(forKey: Key4.key) == Key4.value)
            
            #expect(storage.storageValue(forKey: Key5.key) == Key5.value)
            
            #expect(storage.storageValue(forKey: Key6.key) == Key6.value)
            
            let key7: [Any] = try #require(storage.storageValue(forKey: Key7.key))
            try #require(key7.count == 3)
            #expect(try #require(key7[0] as? String) == Key7.valueIndex0)
            #expect(try #require(key7[1] as? Int) == Key7.valueIndex1)
            #expect(try #require(key7[2] as? Bool) == Key7.valueIndex2)
            
            let key8: [Any] = try #require(storage.storageValue(forKey: Key8.key))
            try #require(key8.count == 2)
            // element 0
            let key8Element0 = try #require(key8[0] as? [String])
            try #require(key8Element0.count == 1)
            #expect(key8Element0[0] == Key8.valueIndex0Index0)
            // element 1
            let key8Element1 = try #require(key8[1] as? [String: Any])
            try #require(key8Element1.count == 2)
            #expect(key8Element1[Key8.KeyA.key] as? String == Key8.KeyA.value)
            #expect(key8Element1[Key8.KeyB.key] as? Int == Key8.KeyB.value)
            
            #expect(storage.storageValue(forKey: Key9.key) == Key9.value)
            
            let key10: [String: Any] = try #require(storage.storageValue(forKey: Key10.key))
            try #require(key10.count == 3)
            #expect(key10[Key10.KeyA.key] as? String == Key10.KeyA.value)
            #expect(key10[Key10.KeyB.key] as? Int == Key10.KeyB.value)
            #expect(key10[Key10.KeyC.key] as? Data == Key10.KeyC.value)
            
            let key11: [String: Any] = try #require(storage.storageValue(forKey: Key11.key))
            try #require(key11.count == 2)
            // key A
            let key11A = try #require(key11[Key11.KeyA.key] as? [String])
            #expect(key11A == Key11.KeyA.value)
            // key B
            let key11B = try #require(key11[Key11.KeyB.key] as? [String: Any])
            try #require(key11B.count == 2)
            #expect(key11B[Key11.KeyB.KeyI.key] as? String == Key11.KeyB.KeyI.value)
            #expect(key11B[Key11.KeyB.KeyII.key] as? Int == Key11.KeyB.KeyII.value)
        }

    }
}