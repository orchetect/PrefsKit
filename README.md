# PrefsKit

[![Platforms - macOS | iOS | tvOS | watchOS | visionOS](https://img.shields.io/badge/platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS%20|%20visionOS-blue.svg?style=flat)](https://developer.apple.com/swift) ![Swift 6.0](https://img.shields.io/badge/Swift-6.0-blue.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/PrefsKit/blob/main/LICENSE)

Swift library for reading & writing preferences:

- using a simple but powerful DSL
- with interchangeable/mockable storage backend
- with `Observable` properties for easy integration in modern SwiftUI apps

## Quick Start

1. Add PrefsKit to your app or package

2. Create a schema that defines the backing storage and preference key/value types.
   - Apply the `@PrefsSchema` attribute to the class.
   - Use `@Pref(key:)` attributes to declare individual preferences by key name and value type. Atomic value types available: 
     - `String`, `Bool`, `Int`, `Double`, `Float`, `Data`
     - Array containing values of the above atomic types
     - Dictionary keyed by `String` containing values of the above atomic types
   ```swift
   import Foundation
   import PrefsKit
   
   @PrefsSchema final class Prefs {
       let storage = UserDefaultsPrefsStorage()
       let storageMode: PrefsSchemaMode = .cachedReadStorageWrite
       
       @Pref(key: "foo") var foo: String?
       @Pref(key: "bar") var bar: Int?
       @Pref(key: "isBaz") var isBaz: Bool = false
   }
   ```
   
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
   
4. The class is implicitly `@Observable` so its properties may be observed or bound to like any other `@Observable` class.
   ```swift
   struct ContentView: View {
       @Environment(Prefs.self) private var prefs
       
       var body: some View {
           Text("String: \(prefs.foo ?? "unknown")")
           Text("Int: \(prefs.bar ?? 0)")
           Toggle("Toggle State", isOn: $prefs.isBaz)
       }
   }
   ```

## Swift Package Manager (SPM)

Add the package to your project or Swift package using  `https://github.com/orchetect/PrefsKit` as the URL.

## Author

Coded by a bunch of 🐹 hamsters in a trench coat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/PrefsKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
