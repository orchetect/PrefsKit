//
//  AnyPrefsArray.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

/// A type that wraps an array of type-erased values for use in prefs storage.
public struct AnyPrefsArray {
    public var content: [AnyPrefsStorageValue]
    
    @inlinable @_disfavoredOverload
    public init(_ content: [AnyPrefsStorageValue]) {
        self.content = content
    }
    
    @inlinable
    public init(_ content: [any PrefsStorageValue]) {
        let converted = content
            .compactMap(AnyPrefsStorageValue.init(_:))
        assert(converted.count == content.count)
        self.content = converted
    }
    
    @inlinable
    public init(userDefaultsValue content: [any PrefsStorageValue]) {
        let converted = content
            .compactMap(AnyPrefsStorageValue.init(userDefaultsValue:))
        assert(converted.count == content.count)
        self.content = converted
    }
}

extension AnyPrefsArray: Equatable { }

extension AnyPrefsArray: Sendable { }

extension AnyPrefsArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: (any PrefsStorageValue)...) {
        self.init(elements)
    }
}

extension AnyPrefsArray: CustomStringConvertible {
    public var description: String {
        "[" + content
            .map { $0.value.prefsStorageValue }
            .map(String.init(describing:))
            .joined(separator: ", ")
            + "]"
    }
}

// MARK: - Array Proxy Methods

extension AnyPrefsArray {
    @inlinable
    public subscript(index: Int) -> any PrefsStorageValue {
        get {
            content[index].value
        }
        _modify {
            var val = content[index].value
            yield &val
            guard let typeErased = AnyPrefsStorageValue(val) else {
                assertionFailure()
                return
            }
            content[index] = typeErased
        }
        set {
            guard let typeErased = AnyPrefsStorageValue(newValue) else {
                assertionFailure()
                return
            }
            content[index] = typeErased
        }
    }
    
    @inlinable
    public var count: Int {
        content.count
    }
    
    @inlinable
    public mutating func append(_ newElement: any PrefsStorageValue) {
        guard let newElement = AnyPrefsStorageValue(newElement)
        else {
            assertionFailure()
            return
        }
        append(newElement)
    }
    
    @inlinable
    public mutating func append(_ newElement: AnyPrefsStorageValue) {
        content.append(newElement)
    }
    
    @inlinable
    public mutating func append(contentsOf newElements: [any PrefsStorageValue]) {
        let converted = newElements
            .compactMap(AnyPrefsStorageValue.init)
        assert(converted.count == newElements.count)
        append(contentsOf: newElements)
    }
    
    @inlinable
    public mutating func append(contentsOf newElements: [AnyPrefsStorageValue]) {
        content.append(contentsOf: newElements)
    }
    
    @inlinable
    public mutating func append(contentsOf newElements: AnyPrefsArray) {
        content.append(contentsOf: newElements.content)
    }
}
