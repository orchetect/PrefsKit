![PrefsKit](Images/prefskit-banner.png)

# PrefsKit

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2FPrefsKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/PrefsKit) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2FPrefsKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/PrefsKit) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PrefsKit/blob/main/LICENSE)

A modern Swift library for reading & writing app preferences:

- simple but powerful declarative DSL
- swappable/mockable storage backend (UserDefaults, Dictionary, PList file, and more)
- keys are implicitly `@Observable` and `@Bindable` for effortless integration in modern SwiftUI apps
- composable, chainable encoding strategies
- built from the ground up for Swift 6

## Table of Contents

- [Quick Start](#Quick-Start)
- [Documentation](#Documentation)
  - [Storage Value Types](#Storage-Value-Types)
  - [Storage Injection](#Storage-Injection)
  - [Key Naming](#Key-Naming)
  - [Custom Value Coding](#Custom-Value-Coding)
  - [Dynamic Key Access](#Dynamic-Key-Access)
  - [Composing Value Coding Strategies](#Composing-Value-Coding-Strategies)
  - [Using Actors](#Using-Actors)
- [FAQ](#FAQ)

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
> [!TIP]
>
> For a list of available storage value types, see [Storage Value Types](#Storage-Value-Types).
3. Instantiate the class in the appropriate scope. If you are defining application preferences, the `App` struct is a good place to store it. It may be passed into the environment so that any subview can access it.
   ```swift
   struct MyApp: App {
       @State private var prefs = Prefs()
       
       var body: some Scene {
           WindowGroup {
               ContentView()
                   .environment(prefs)
           }
       }
   }
   ```
4. The class is implicitly `@Observable` so its properties can trigger SwiftUI view updates and be used as bindings.
   ```swift
   struct ContentView: View {
       @Environment(Prefs.self) private var prefs
       
       var body: some View {
           @Bindable var prefs = prefs
           
           Text("String: \(prefs.foo ?? "Not yet set.")")
           Text("Int: \(prefs.bar)")
           Toggle("State", isOn: $prefs.bool)
       }
   }
   ```

## Documentation

### Storage Value Types

These are the atomic value types supported:

| Atomic Type        | Usage                                   | Description                                            |
| ------------------ | --------------------------------------- | ------------------------------------------------------ |
| `String`           | `@Pref var x: String = ""`              | An atomic `String` value                               |
| `Bool`             | `@Pref var x: Bool = true`              | An atomic `Bool` value                                 |
| `Int`              | `@Pref var x: Int = 1`                  | An atomic `Int` value                                  |
| `Double`           | `@Pref var x: Double = 1.0`             | An atomic `Double` value                               |
| `Float`            | `@Pref var x: Float = 1.0`              | An atomic `Float` value                                |
| `Data`             | `@Pref var x: Data = Data()`            | An atomic `Data` value                                 |
| Array              | `@Pref var x: [String] = []`            | Array of a single atomic value type                    |
| Array (Mixed)      | `@Pref var x: AnyPrefsArray = []`       | Array of a mixture of atomic value types               |
| Dictionary         | `@Pref var x: [String: String] = [:]`   | Keyed by `String` with a single atomic value type      |
| Dictionary (Mixed) | `@Pref var x: AnyPrefsDictionary = [:]` | Keyed by `String` with a mixture of atomic value types |

> [!NOTE]
>
> Instead of `[Any]`, the custom `AnyPrefsArray` type ensures type safety for its elements.
>
> Likewise, instead of `[String: Any]`, the custom `AnyPrefsDictionary` type ensures type safety for its key values.

### Storage Injection

For more complex scenarios, a `@PrefsSchema` class can have its storage backend and/or storage mode set at class init.

One method is by way of type-erasure using the concrete type `AnyPrefsStorage` and passing your storage of choice in.

```swift
@PrefsSchema final class Prefs {
    @Storage var storage: AnyPrefsStorage
    @StorageMode var storageMode: PrefsStorageMode
    
    init(storage: any PrefsStorage, storageMode: PrefsStorageMode) {
        self.storage = AnyPrefsStorage(storage)
        self.storageMode = storageMode
    }
}
```

Another method is by way of generics if, for example, you know the storage backend will always be a dictionary.

The benefit of this approach is that it gives access to type-specific members of the concrete storage type instead of only protocolized `PrefsStorage` members.

```swift
@PrefsSchema final class Prefs {
    @Storage var storage: DictionaryPrefsStorage
    @StorageMode var storageMode: PrefsStorageMode
    
    init(storage: DictionaryPrefsStorage, mode: PrefsStorageMode) {
        self.storage = storage
        storageMode = mode
    }
}
```

### Key Naming

Key names are synthesized from the var name unless specified:

```swift
@Pref var foo: String? // storage key name is "foo"

@Pref(key: "bar") var foo: String? // storage key name is "bar"
```

### Custom Value Coding

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
#### `@JSONDataCodablePref` / `@JSONStringCodablePref`

Several syntax options are available to encode and decode any `Codable` type as JSON using either `Data` or `String` raw storage.

```swift
struct Device: Codable {
    var name: String
    var manufacturer: String
}
```

Convenience macros:

```swift
@PrefsSchema final class Prefs {
    // encode Device as JSON using Data storage
    @JSONDataCodablePref var device: Device?
    
    // encode Device as JSON using String storage
    @JSONStringCodablePref var device: Device?
}
```
Or using `Pref(coding:)` which also allows for chaining of coding strategies. The initial coding strategy must be specified by using the synthesized extension property on its concrete type, as shown:

```swift
@PrefsSchema final class Prefs {
    // encode Device as JSON using Data storage
    @Pref(coding: Device.jsonDataPrefsCoding) var device: Device?
    
    // encode Device as JSON using String storage
    @Pref(coding: Device.jsonStringPrefsCoding) var device: Device?
}
```

#### `@Pref(encode:decode:)` and `@Pref(coding:)`

Supports custom *value ←→ storage value* encoding implementation.

It can be done inline:

```swift
@PrefsSchema final class Prefs {
    @Pref(encode: { $0.rawValue }, decode: { MyType(rawValue: $0) })
    var url: MyType?
}

struct MyType {
    var rawValue: String
    init?(rawValue: String) { /* ... */ }
}
```

Or if a coding implementation needs to be reused, it can be defined once by creating a new type that conforms to `PrefsCodable`, then supply an instance of the type in each `@Pref` declaration's `coding` parameter:

```swift
@PrefsSchema final class Prefs {
    @Pref(coding: .myType) var foo: MyType?
    @Pref(coding: .myType) var bar: MyType?
}

struct MyTypePrefsCoding: PrefsCodable {
    func encode(prefsValue: MyType) -> String? {
        prefsValue.rawValue
    }
    func decode(prefsValue: String) -> MyType? {
        MyType(rawValue: prefsValue)
    }
}

extension PrefsCoding where Self == MyTypePrefsCoding {
    static var myType: MyTypePrefsCoding { MyTypePrefsCoding() }
}
```

> [!NOTE]
>
> This approach of defining a custom `PrefsCodable` implementation is ideal when the type being encoded is either:
> - a type that you do not own (ie: from another framework), or
> - when the type may have more than one possible encoding format, or
> - a type whose encoding format has changed over time and generational formats need to be maintained (ie: for legacy preferences migration)
>
> If it is for a custom type that is one you own and there is only one encoding format for it, one alternative approach is to conform it to Swift's `Codable` instead and use `@JSONDataCodablePref` or `@JSONStringCodablePref` to store it.

### Composing Value Coding Strategies

For more complex preference value coding scenarios, two or more coding strategies may be chained in series in order to compose multiple steps in the encoding/decoding process.

By way of example, a custom type that conforms to `Codable` could be first encoded to its data representation, then compressed, then encoded to a base-64 encoded `String` as its final preferences storage format. When the value is read back from storage, the decoding process naturally occurs in the reverse order.

```swift
@PrefsSchema final class Prefs {
    @Pref(coding: MyType.jsonDataPrefsCoding
                        .compressedData(algorithm: .lzfse)
                        .base64DataString()
    ) var foo: MyType?
}

struct MyType: Codable {
    var id: Int
    var content: String
}
```

### Dynamic Key Access

In complex projects it may be necessary to access the prefs storage directly using preference key(s) that may only be known at runtime.

The storage property may be accessed directly using `value(forKey:)` and `setValue(forKey:to:)` methods.

```swift
@PrefsSchema final class Prefs {
    // @Pref vars are Observable and Bindable in SwiftUI views
    @Pref var foo: Int?
    
    // `storage` access is NOT Observable or Bindable in SwiftUI views
    func fruit(name: String) -> String? {
        storage.value(forKey: "fruit-\(name)")
    }
    func setFruit(name: String, to newValue: String?) {
        storage.setValue(forKey: "fruit-\(name)", to: newValue)
    }
}
```

> [!NOTE]
> Mutating storage directly does not inherit the `@Observable` behavior of `@Pref`-defined keys, which inherently means this type of access cannot be used in a SwiftUI Binding. For these reasons it is ideal that the prefs schema contain root-level preference keys that are known at compile time where possible.

### Using Actors

Because of internal protocol requirements of `@PrefsSchema`, actors (such as `@MainActor`) cannot be directly attached to the class declaration.

```swift
@MainActor // <-- ❌ not possible
@PrefsSchema final class Prefs { /* ... */ }
```

Actors may, however, be attached to individual `@Pref` preference declarations.

```swift
@PrefsSchema final class Prefs {
    @Storage var storage = .userDefaults
    @StorageMode var storageMode = .cachedReadStorageWrite
    
    @MainActor // <-- ✅ possible
    @Pref var foo: Int?
    
    @Pref var bar: String?
}
```

> [!NOTE]
> This may be subject to change in future versions of PrefsKit.

## FAQ

- **Why use PrefsKit?**

  Offering users customization points in your software is a foundational way to offer a great user experience — but it's not the main event. You'd rather be putting time and resources into developing the actual features users are customizing than dealing with the overhead of how these options are stored and handled. And so often the problem is handled by way of path of least resistance, which usually goes something like "just use `UserDefaults` and move on" or "`@AppStorage` is good enough, right?"

  The danger of this convenient low-hanging fruit is the tech debt it inevitably creates over time. As a project grows and changes shape, its needs increase, and its automated testing requirements broaden. By then, large portions of the codebase are tightly coupled with implementation details (ie: `UserDefaults` access) and refactors to allow modular preferences become increasingly expensive.

  So, tired of every project having a haphazard approach to handling preferences — and inspired by patterns in first-party Apple packages such as SwiftData — a one-stop shop solution was built. It's simple, powerful, and uses modern Swift language features to allow preferences to be declarative while hiding implementation details so you can get on with the important stuff - like building features users care about. It can be minimal so it's easy to set up for small projects, but it can also scale for projects with larger demands.

- **Why not just use `@AppStorage`?**

  The 1st-party provided `@AppStorage` property wrapper is convenient and perfectly fine for small apps that do not require robust storage flexibility or prefs isolation / mocking for integration testing or unit testing.

  It also is fairly limited in the value types it supports. PrefsKit offers an easy to use, extensible blueprint for defining and using encoding strategies for any value type.

- **Why not just use SwiftData?**

  SwiftData is more oriented towards data models and user document content. It requires some adaptation and boilerplate to shoehorn it into the role of application preferences storage. It also has a somewhat steep learning curve and may contain more features than are necessary.

  PrefsKit is purpose-built for preference storage.

- **Why not just use `UserDefaults` directly?**

  For small apps this approach may be adequate. However it forms tight coupling to `UserDefaults` as a storage backend. This means automated integration testing can't as easily be performed with isolated/mocked preferences. Even if the approach of using separate `UserDefaults` suites for testing is employed, the coupling makes changing storage backend in the future more time-intensive.

  PrefsKit adds the ability to swap out the storage backend at any time in the future, in addition to its easy to use, extensible blueprints for defining and using encoding strategies for value types.

## Swift Package Manager (SPM)

Add the package to your project or Swift package using `https://github.com/orchetect/PrefsKit` as the URL.

Note that PrefsKit makes use of [Swift Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/) and because of this, Xcode will prompt you to allow macros for this package. It will ask again any time a new release of the package is available and you update to it.

## Author

Coded by a bunch of 🐹 hamsters in a trench coat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/PrefsKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
