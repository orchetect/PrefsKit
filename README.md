![PrefsKit](Images/prefskit-banner.png)

# PrefsKit

[![Platforms - macOS | iOS | tvOS | watchOS | visionOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg?style=flat)](https://developer.apple.com/swift) ![Swift 6.0](https://img.shields.io/badge/Swift-6.0-blue.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PrefsKit/blob/main/LICENSE)

A modern Swift library for reading & writing app preferences:

- simple but powerful declarative DSL
- swappable/mockable storage backend (UserDefaults, Dictionary, PList file, and more)
- keys are implicitly `@Observable` and `@Bindable` for effortless integration in modern SwiftUI apps
- built from the ground up for Swift 6

## Table of Contents

- [Quick Start](#Quick-Start)
- [Documentation](#Documentation)
  - [Storage Value Types](#Storage-Value-Types)
  - [Storage Injection](#Storage-Injection)
  - [Key Naming](#Key-Naming)
  - [Custom Value Coding](#Custom-Value-Coding)
  - [Dynamic Key Access](#Dynamic-Key-Access)
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

| Atomic Type               | Usage                                     | Description                                                  |
| ------------------------- | ----------------------------------------- | ------------------------------------------------------------ |
| `String`                  | `@Pref var foo: String = ""`              | An atomic String value                                       |
| `Bool`                    | `@Pref var foo: Bool = true`              | An atomic `Bool` value                                       |
| `Int`                     | `@Pref var foo: Int = 1`                  | An atomic `Int` value                                        |
| `Double`                  | `@Pref var foo: Double = 1.0`             | An atomic `Double` value                                     |
| `Float`                   | `@Pref var foo: Float = 1.0`              | An atomic `Float` value                                      |
| `Data`                    | `@Pref var foo: Data = Data()`            | An atomic `Data` value                                       |
| Array                     | `@Pref var foo: [String] = []`            | Array of a single atomic value type. ie: `[String]` or `[Int]` |
| Array (Mixed)             | `@Pref var foo: AnyPrefsArray = []`       | Array of a mixture of atomic value types.                    |
| Dictionary                | `@Pref var foo: [String: String] = [:]`   | Dictionary keyed by `String` with values of a single atomic value type. |
| Dictionary (Mixed Values) | `@Pref var foo: AnyPrefsDictionary = [:]` | Dictionary keyed by `String` with values of a mixture of atomic value types. |

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

Convenience to encode and decode any `Codable` type as JSON using either `Data` or `String` raw storage.

```swift
@PrefsSchema final class Prefs {
    // encode Device as JSON using Data storage
    @JSONDataCodablePref var device: Device?
    
    // encode UUID as JSON using String storage
    @JSONStringCodablePref var deviceID: UUID? // UUID natively conforms to Codable
}
  
struct Device: Codable {
    var name: String
    var manufacturer: String
}
```
#### `@Pref(encode:decode:)` and `@Pref(coding:)`

Supports custom *value ←→ storage value* encoding implementation.

It can be done inline:

```swift
@PrefsSchema final class Prefs {
    @Pref(encode: { $0.absoluteString }, decode: { URL(string: $0) })
    var url: URL?
}
```

Or if a coding implementation needs to be reused, it can be defined once and specified in each preference declaration:

```swift
@PrefsSchema final class Prefs {
    @Pref(coding: .urlString) var foo: URL?
    @Pref(coding: .urlString) var bar: URL?
}

struct URLStringPrefsCoding: PrefsCodable {
    func encode(prefsValue: URL) -> String? {
        prefsValue.absoluteString
    }
    func decode(prefsValue: String) -> URL? {
        URL(string: prefsValue)
    }
}

extension PrefsCoding where Self == URLStringPrefsCoding {
    static var urlString: URLStringPrefsCoding { URLStringPrefsCoding() }
}
```

> [!NOTE]
>
> The approach of defining a custom `PrefsCodable` implementation is ideal when it is either:
> - a type that you do not own (ie: from another framework), or
> - when the type may have more than one possible encoding format, or
> - a type whose encoding format has changed over time and multiple formats need to be maintained (ie: for legacy preferences migration)
>
> If it is for a custom type that is one you own and there is only one encoding format for it, an alternative approach could be to conform it to Swift's `Codable` instead and use `@JSONDataCodablePref` or `@JSONStringCodablePref` to store it.

### Dynamic Key Access

In complex projects it may be necessary to access the prefs storage directly using preference key(s) that may only be known at runtime.

The storage property may be accessed directly using `value(forKey:)` and `setValue(forKey:to:)` methods.

Note that mutating storage directly does not inherit the `@Observable` behavior of `@Pref`-defined keys, and of course they cannot be directly used in a SwiftUI Binding / Bindable context.

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

### Using Actors

Because of internal protocol requirements, actors (such as `@MainActor`) cannot be directly attached to the `@PrefsSchema` class declaration.

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

## FAQ

- **Why?**

  We all know how it goes - whether you get a spark of an idea for a new app or have been working on a larger codebase - preferences are a necessary but rudimentary part of building an application. But they're not the main event. And so often the problem is solved by way of path of least resistance, which usually goes something like "just use `UserDefaults` and move on" or "`@AppStorage` is good enough."

  The danger of this convenient low-hanging fruit is the tech debt it inevitably creates over time. As a project grows and changes shape, its needs increase, and its automated testing requirements broaden. By then, large portions of the codebase are tightly coupled with specific implementation details (ie: `UserDefaults` access) and refactors to allow modular preferences become increasingly daunting.

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
