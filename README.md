![PrefsKit](Images/prefskit-banner.png)

# PrefsKit

[![Platforms - macOS | iOS | tvOS | watchOS | visionOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg?style=flat)](https://developer.apple.com/swift) ![Swift 6.0](https://img.shields.io/badge/Swift-6.0-blue.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PrefsKit/blob/main/LICENSE)

A modern Swift library for reading & writing app preferences:

- simple but powerful DSL
- swappable/mockable storage backend (UserDefaults, Dictionary, PList file, and more)
- keys are `Observable` for effortless integration in modern SwiftUI apps
- built from the ground up for Swift 6

## Quick Start

1. Add PrefsKit to your app or package
2. Create a schema that defines the backing storage and preference key/value types.
   - Apply the `@PrefsSchema` attribute to the class.
   - Define your `storage` and `storageMode` using the corresponding `@Storage` and `@StorageMode` attributes.
   - Use the `@Pref` attribute to declare individual preference keys and their value type.
     Value types may be `Optional` or have a default value.
   ```swift
   import Foundation
   import PrefsKit
   
   @PrefsSchema final class Prefs {
       @Storage var storage = .userDefaults
       @StorageMode var storageMode = .cachedReadStorageWrite
       
       @Pref var foo: String?
       @Pref var bar: Int = 123
       @Pref var bool: Bool = false
       @Pref var array: [String]?
       @Pref var dict: [String: Int]?
   }
   ```
   > Atomic value types available: 
   >
   > - `String`, `Bool`, `Int`, `Double`, `Float`, `Data`
   > - `Array` containing values of the above atomic types
   > - `Dictionary` keyed by `String` containing values of the above atomic types
3. Instantiate the class in the appropriate scope. If you are defining application preferences, the App struct is a good place to store it. It may be passed into the environment so that any subview can access it.
   ```swift
   struct MyApp: App {
       @State private var prefs = Prefs()
       
       var body: some Scene {
           ContentView()
               .environment(prefs)
       }
   }
   ```
4. The class is implicitly `@Observable` so its properties can trigger SwiftUI view updates and be used as bindings.
   ```swift
   struct ContentView: View {
       @Environment(Prefs.self) private var prefs
       
       var body: some View {
           Text("String: \(prefs.foo ?? "Not yet set.")")
           Text("Int: \(prefs.bar)")
           Toggle("Toggle State", isOn: $prefs.bool)
       }
   }
   ```

## Advanced Concepts

### Defining Member Requirements Through Injection

For more complex scenarios, a `@PrefsSchema` class can have its storage backend and/or storage mode set at class init.

One method is by way of type-erasure using the concrete type `AnyPrefsStorage` and passing your storage of choice in.

```swift
@PrefsSchema final class Prefs {
    @Storage var storage: AnyPrefsStorage
    @StorageMode var storageMode: PrefsSchemaMode
    
    init(storage: any PrefsStorage, storageMode: PrefsSchemaMode) {
        self.storage = AnyPrefsStorage(storage)
        self.storageMode = storageMode
    }
}
```

Another method is by way of generics if, for example, you know the storage backend will always be a dictionary.

The benefit of this approach is that it gives access to type-specific members of the concrete storage type instead of only protocolized `PrefsStorage` members.

```swift
@PrefsSchema final class PrefsB {
    @Storage var storage: DictionaryPrefsStorage
    @StorageMode var storageMode: PrefsSchemaMode
    
    init(storage: DictionaryPrefsStorage, mode: PrefsSchemaMode) {
        self.storage = storage
        storageMode = mode
    }
}
```

### Key Names

Key names are synthesized from the var name unless specified:

```swift
@Pref var foo: String? // storage key name is "foo"
@Pref(key: "bar") var foo: String? // storage key name is "Bar"
```

### Complex Value Types

Alternative macros are available for more complex types such as:

#### `@RawRepresentablePref`

Allows using a `RawRepresentable` type with a `RawValue` that is one of the supported atomic storage value types.

```swift
@PrefsSchema final class Prefs {
    @RawRepresentablePref var fruit: Fruit?
}
  
enum Fruit: String {
    case apple, banana, orange
}
```
#### `@JSONCodablePref`

Convenience to encode and decode any `Codable` type as JSON `Data`.

```swift
@PrefsSchema final class Prefs {
    @JSONCodablePref var device: Device?
    @JSONCodablePref var deviceID: UUID? // UUID natively conforms to Codable
}
  
struct Device: Codable {
    var name: String
    var manufacturer: String
}
```
#### `@Pref(encode:decode:)` and `@Pref(coding:)`

Supports custom *value ←→ storage value* encoding implementation.

```swift
@PrefsSchema final class Prefs {
    // can be defined inline
    @Pref(encode: { $0.absoluteString }, decode: { URL(string: $0) })
    var url: URL?
    
    // or coding can be defined once and used multiple times
    let urlCoding = PrefsCoding(encode: { $0.absoluteString },
                                decode: { URL(string: $0) })
    @Pref(coding: urlCoding) var foo: URL?
    @Pref(coding: urlCoding) var bar: URL?
}
```

### Dynamic Key Access

In complex projects it may be necessary to access the prefs storage directly using preference key(s) that may only be known at runtime.

The storage property may be accessed directly using `value(forKey:)` and `setValue(forKey:to:)` methods.

Note that mutating storage directly does not inherit the `@Observable` behavior of `@Pref`-defined keys, and of course they cannot be directly used in a SwiftUI Binding / Bindable context.

```swift
@PrefsSchema final class Prefs {
    // @Pref vars are Observable and Bindable in SwiftUI views
    @Pref var foo: Int?
    
    // `storage` acces is NOT Observable or Bindable in SwiftUI views
    func fruit(name: String) -> String? {
        storage.value(forKey: "fruit-\(name)")
    }
    func setFruit(name: String, to newValue: String?) {
        storage.setValue(forKey: "fruit-\(name)", to: newValue)
    }
}
```

In consideration of the aforementioned drawbacks, it is ideal to whatever extent possible, have a prefs schema that contains root-level preference keys that are known at compile time. A possible alternative would be to create a root-level `@Pref` key that contains an array or dictionary which can then be used for dynamic access. For example:

```swift
@PrefsSchema final class Prefs {
    @Pref var fruit: [String: String] = [:]
    
    // this method is an unnecessary proxy, but WILL be Observable
    func fruit(name: String) -> String? {
        fruit[name]
    }
}

struct ContentView: View {
    @Environment(Prefs.self) private var prefs
    
    var body: some View {
        Text("Apple's value: \(prefs.fruit["apple"] ?? "Missing."))
    }
}
```

## FAQ

- Why?

  Preferences are an oft-relegated piece of minutiae of almost every project that is considered not worthy of much attention, which usually goes something like "just use `UserDefaults`, and move on" or "`@AppStorage` is good enough." The danger of this low-hanging and tempting fruit is the tech debt that it inevitably creates over the long-term as a project grows changes shape, and its automated testing requirements broaden.

  By then, large portions of the codebase are tightly coupled with specific implementation details (ie: `UserDefaults` access).

  So, tired of every project having an often half-baked roll-your-own preferences architecture, and inspired by patterns in 1st-party Apple packages such as SwiftData, a one-stop-shop solution was built that is simple, powerful, and uses modern Swift language features for declarative preferences. It can minimal so it's easy to set up for small projects, but can also scale for projects with larger demands.

- Why not just use `@AppStorage`?

  The 1st-party provided `@AppStorage` property wrapper is convenient and perfectly fine for small apps that do not require robust storage flexibility or prefs isolation / mocking for integration testing or unit testing.

  It also is fairly limited in the value types it supports. PrefsKit offers an easy to use, extensible blueprint for defining and using encoding strategies for any value type.

- Why not just use SwiftData?

  SwiftData is more oriented towards data models and user document content. It requires some adaptation and boilerplate to shoehorn it into the role of application preferences storage. It also has a somewhat steep learning curve and may contain more features than are necessary.

  PrefsKit is purpose-built for preference storage.

- Why not just use `UserDefaults` directly?

  For small apps this approach may be adequate. However it forms tight coupling to `UserDefaults` as a storage backend. This means automated integration testing can't as easily be performed with isolated/mocked preferences. Even if the approach of using separate `UserDefaults` suites for testing is employed, the coupling makes changing storage backend in the future more time-intensive.

  PrefsKit adds the ability to swap out the storage backend at any time in the future, in addition to its easy to use, extensible blueprints for defining and using encoding strategies for value types.

## Swift Package Manager (SPM)

Add the package to your project or Swift package using  `https://github.com/orchetect/PrefsKit` as the URL.

## Author

Coded by a bunch of 🐹 hamsters in a trench coat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/PrefsKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
