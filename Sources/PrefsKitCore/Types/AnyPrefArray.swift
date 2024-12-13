//
//  AnyPrefArray.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A type that wraps an array of type-erased values for use in prefs storage.
public struct AnyPrefArray {
    public var content: [AnyPrefsStorageValue]
    
    public init(_ content: [AnyPrefsStorageValue]) {
        self.content = content
    }
    
    public init(_ content: [any PrefsStorageValue]) {
        let converted = content
            .compactMap(AnyPrefsStorageValue.init)
        assert(converted.count == content.count)
        self.content = converted
    }
}

extension AnyPrefArray: Equatable { }

extension AnyPrefArray: Sendable { }

extension AnyPrefArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: (any PrefsStorageValue)...) {
        self.init(elements)
    }
}

// MARK: - Array Proxy Methods

extension AnyPrefArray {
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
    
    public var count: Int {
        content.count
    }
    
    public mutating func append(_ newElement: any PrefsStorageValue) {
        guard let newElement = AnyPrefsStorageValue(newElement)
        else {
            assertionFailure()
            return
        }
        append(newElement)
    }
    
    public mutating func append(_ newElement: AnyPrefsStorageValue) {
        content.append(newElement)
    }
    
    public mutating func append(contentsOf newElements: [any PrefsStorageValue]) {
        let converted = newElements
            .compactMap(AnyPrefsStorageValue.init)
        assert(converted.count == newElements.count)
        append(contentsOf: newElements)
    }
    
    public mutating func append(contentsOf newElements: [AnyPrefsStorageValue]) {
        content.append(contentsOf: newElements)
    }
    
    public mutating func append(contentsOf newElements: AnyPrefArray) {
        content.append(contentsOf: newElements.content)
    }
}
