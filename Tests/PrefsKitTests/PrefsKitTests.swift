import Testing
@testable import PrefsKit

// MARK: Mock Types

enum RawEnum: String, RawRepresentable {
    case one
}

// MARK: - Protocol Adoptions
struct Foo: PrefKey {
    typealias StorageValue = Bool
    let key: String = ""
}

struct Bar: DefaultedPrefKey {
    typealias StorageValue = Bool
    let key: String = ""
    let defaultValue: StorageValue = true
}

struct RawFoo: RawRepresentablePrefKey {
    typealias T = RawEnum
    let key: String = ""
}

struct RawBar: RawRepresentableDefaultedPrefKey {
    typealias T = RawEnum
    let key: String = ""
    let defaultValue: T = .one
}

let foo = Foo()
let bar = Bar()
let rawFoo = RawFoo()
let rawbar = RawBar()

@Test func basic() async throws {
    _ = foo.getValue()
    _ = bar.getValueDefaulted()
    _ = rawFoo.getValue()
    _ = rawbar.getValueDefaulted()
}
