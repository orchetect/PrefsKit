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

@Test func basic() async throws {
    // empty
}
