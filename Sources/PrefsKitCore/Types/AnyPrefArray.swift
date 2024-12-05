//
//  AnyPrefArray.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public struct AnyPrefArray {
    public var content: [AnyPrefStorageValue]
    
    public init(_ content: [AnyPrefStorageValue]) {
        self.content = content
    }
    
    public init(_ content: [any PrefStorageValue]) {
        let converted = content
            .compactMap(AnyPrefStorageValue.init)
        assert(converted.count == content.count)
        self.content = converted
    }
}

extension AnyPrefArray: Equatable { }

extension AnyPrefArray: Sendable { }

extension AnyPrefArray: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: (any PrefStorageValue)...) {
        self.init(elements)
    }
}

// MARK: - Array Proxy Methods

extension AnyPrefArray {
    public subscript(index: Int) -> any PrefStorageValue {
        get {
            content[index].value
        }
        _modify {
            var val = content[index].value
            yield &val
            guard let typeErased = AnyPrefStorageValue(val) else {
                assertionFailure()
                return
            }
            content[index] = typeErased
        }
        set {
            guard let typeErased = AnyPrefStorageValue(newValue) else {
                assertionFailure()
                return
            }
            content[index] = typeErased
        }
    }
    
    public var count: Int {
        content.count
    }
    
    public mutating func append(_ newElement: any PrefStorageValue) {
        guard let newElement = AnyPrefStorageValue(newElement)
        else {
            assertionFailure()
            return
        }
        append(newElement)
    }
    
    public mutating func append(_ newElement: AnyPrefStorageValue) {
        content.append(newElement)
    }
    
    public mutating func append(contentsOf newElements: [any PrefStorageValue]) {
        let converted = newElements
            .compactMap(AnyPrefStorageValue.init)
        assert(converted.count == newElements.count)
        append(contentsOf: newElements)
    }
    
    public mutating func append(contentsOf newElements: [AnyPrefStorageValue]) {
        content.append(contentsOf: newElements)
    }
    
    public mutating func append(contentsOf newElements: AnyPrefArray) {
        content.append(contentsOf: newElements.content)
    }
}
