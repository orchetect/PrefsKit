//
//  PrefsSchema.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation

/// Protocol for prefs schema.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol PrefsSchema /*where Self: Sendable*/ {
    /// Storage provider type for prefs.
    associatedtype Storage: PrefsStorage
    
    /// Storage provider for prefs.
    var storage: Storage { get }
}

// @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
// extension PrefsSchema {
//     /// Wrap a pref key instance. Used in ``PrefsSchema``.
//     public func pref<Key: PrefsCodable>(_ key: Key) -> ObservablePref<Key> {
//         ObservablePref(key: key, storage: storage, isCacheEnabled: isCacheEnabled)
//     }
// 
//     /// Wrap a pref key instance. Used in ``PrefsSchema``.
//     public func pref<Key: DefaultedPrefsCodable>(_ key: Key) -> ObservableDefaultedPref<Key> {
//         ObservableDefaultedPref(key: key, storage: storage, isCacheEnabled: isCacheEnabled)
//     }
// }
// 
// @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
// extension PrefsSchema {
//     // MARK: - Atomic
// 
//     /// Synthesize a pref key with an `Int` value.
//     public func pref(
//         int key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<Int>> {
//         let keyInstance = AnyAtomicPrefsCoding<Int>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `String` value.
//     public func pref(
//         string key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<String>> {
//         let keyInstance = AnyAtomicPrefsCoding<String>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Bool` value.
//     public func pref(
//         bool key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<Bool>> {
//         let keyInstance = AnyAtomicPrefsCoding<Bool>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Double` value.
//     public func pref(
//         double key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<Double>> {
//         let keyInstance = AnyAtomicPrefsCoding<Double>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Float` value.
//     public func pref(
//         float key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<Float>> {
//         let keyInstance = AnyAtomicPrefsCoding<Float>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Data` value.
//     public func pref(
//         data key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<Data>> {
//         let keyInstance = AnyAtomicPrefsCoding<Data>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Array` value.
//     public func pref(
//         array key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<AnyPrefArray>> {
//         let keyInstance = AnyAtomicPrefsCoding<AnyPrefArray>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Array` value.
//     public func pref<Element: PrefStorageValue>(
//         array key: String,
//         of elementType: Element.Type
//     ) -> ObservablePref<AnyAtomicPrefsCoding<[Element]>> {
//         let keyInstance = AnyAtomicPrefsCoding<[Element]>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Dictionary` value.
//     public func pref<Element: PrefStorageValue>(
//         dictionary key: String,
//         of elementType: Element.Type
//     ) -> ObservablePref<AnyAtomicPrefsCoding<[String: Element]>> {
//         let keyInstance = AnyAtomicPrefsCoding<[String: Element]>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Dictionary` value.
//     public func pref(
//         dictionary key: String
//     ) -> ObservablePref<AnyAtomicPrefsCoding<AnyPrefDictionary>> {
//         let keyInstance = AnyAtomicPrefsCoding<AnyPrefDictionary>(key: key)
//         return pref(keyInstance)
//     }
// 
//     // MARK: - Atomic Defaulted
// 
//     /// Synthesize a pref key with an `Int` value with a default value.
//     public func pref(
//         int key: String,
//         default defaultValue: Int
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<Int>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<Int>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `String` value with a default value.
//     public func pref(
//         string key: String,
//         default defaultValue: String
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<String>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<String>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Bool` value with a default value.
//     public func pref(
//         bool key: String,
//         default defaultValue: Bool
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<Bool>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<Bool>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Double` value with a default value.
//     public func pref(
//         double key: String,
//         default defaultValue: Double
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<Double>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<Double>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Float` value with a default value.
//     public func pref(
//         float key: String,
//         default defaultValue: Float
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<Float>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<Float>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with a `Data` value with a default value.
//     public func pref(
//         data key: String,
//         default defaultValue: Data
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<Data>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<Data>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Array` value with a default value.
//     public func pref(
//         array key: String,
//         default defaultValue: AnyPrefArray
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<AnyPrefArray>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<AnyPrefArray>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Array` value with a default value.
//     public func pref<Element: PrefStorageValue>(
//         array key: String,
//         of elementType: Element.Type,
//         default defaultValue: [Element]
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<[Element]>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<[Element]>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Dictionary` value with a default value.
//     public func pref(
//         dictionary key: String,
//         default defaultValue: AnyPrefDictionary
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<AnyPrefDictionary>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<AnyPrefDictionary>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Dictionary` value with a default value.
//     public func pref<Element: PrefStorageValue>(
//         dictionary key: String,
//         of elementType: Element.Type,
//         default defaultValue: [String: Element]
//     ) -> ObservableDefaultedPref<AnyDefaultedAtomicPrefsCoding<[String: Element]>> {
//         let keyInstance = AnyDefaultedAtomicPrefsCoding<[String: Element]>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     // MARK: - RawRepresentable
// 
//     /// Synthesize a pref key with an `RawRepresentable` value.
//     public func pref<Value: RawRepresentable, StorageValue: PrefStorageValue>(
//         _ key: String,
//         of elementType: Value.Type
//     ) -> ObservablePref<AnyRawRepresentablePrefsCodable<Value, StorageValue>> {
//         let keyInstance = AnyRawRepresentablePrefsCodable<Value, StorageValue>(key: key)
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `RawRepresentable` value with a default value.
//     public func pref<Value: RawRepresentable, StorageValue: PrefStorageValue>(
//         _ key: String,
//         of elementType: Value.Type,
//         default defaultValue: Value
//     ) -> ObservableDefaultedPref<AnyDefaultedRawRepresentablePrefsCoding<Value, StorageValue>> {
//         let keyInstance = AnyDefaultedRawRepresentablePrefsCoding<Value, StorageValue>(key: key, defaultValue: defaultValue)
//         return pref(keyInstance)
//     }
// 
//     // MARK: - Codable
// 
//     /// Synthesize a pref key with an `Codable` value.
//     @_disfavoredOverload
//     public func pref<
//         Value: Codable,
//         StorageValue: PrefStorageValue,
//         Encoder: TopLevelEncoder,
//         Decoder: TopLevelDecoder
//     >(
//         _ key: String,
//         of elementType: Value.Type,
//         encoder: @escaping @Sendable @autoclosure () -> Encoder,
//         decoder: @escaping @Sendable @autoclosure () -> Decoder
//     ) -> ObservablePref<AnyCodablePrefsCoding<Value, StorageValue, Encoder, Decoder>> {
//         let keyInstance = AnyCodablePrefsCoding<Value, StorageValue, Encoder, Decoder>(
//             key: key,
//             encoder: encoder(),
//             decoder: decoder()
//         )
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Codable` value with a default value.
//     @_disfavoredOverload
//     public func pref<
//         Value: Codable,
//         StorageValue: PrefStorageValue,
//         Encoder: TopLevelEncoder,
//         Decoder: TopLevelDecoder
//     >(
//         _ key: String,
//         of elementType: Value.Type,
//         default defaultValue: Value,
//         encoder: @escaping @Sendable @autoclosure () -> Encoder,
//         decoder: @escaping @Sendable @autoclosure () -> Decoder
//     ) -> ObservableDefaultedPref<AnyDefaultedCodablePrefsCoding<Value, StorageValue, Encoder, Decoder>> {
//         let keyInstance = AnyDefaultedCodablePrefsCoding<Value, StorageValue, Encoder, Decoder>(
//             key: key,
//             defaultValue: defaultValue,
//             encoder: encoder(),
//             decoder: decoder()
//         )
//         return pref(keyInstance)
//     }
// 
//     // MARK: - JSON Codable
// 
//     /// Synthesize a pref key with an `Codable` value using JSON encoding.
//     @_disfavoredOverload
//     public func pref<Value: Codable>(
//         _ key: String,
//         of elementType: Value.Type
//     ) -> ObservablePref<AnyJSONCodablePrefsCoding<Value>> {
//         let keyInstance = AnyJSONCodablePrefsCoding<Value>(
//             key: key
//         )
//         return pref(keyInstance)
//     }
// 
//     /// Synthesize a pref key with an `Codable` value using JSON encoding with a default value.
//     @_disfavoredOverload
//     public func pref<Value: Codable>(
//         _ key: String,
//         of elementType: Value.Type,
//         default defaultValue: Value
//     ) -> ObservableDefaultedPref<AnyDefaultedJSONCodablePrefsCoding<Value>> {
//         let keyInstance = AnyDefaultedJSONCodablePrefsCoding<Value>(
//             key: key,
//             defaultValue: defaultValue
//         )
//         return pref(keyInstance)
//     }
// }
