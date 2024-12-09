//
//  AnyPrefDictionary.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2024 Steffan Andrews • Licensed under MIT License
//

/// A type that wraps a dictionary of type-erased values for use in prefs storage.
public struct AnyPrefDictionary {
    public var content: [String: AnyPrefStorageValue]
    
    public init(_ content: [String: AnyPrefStorageValue]) {
        self.content = content
    }
    
    public init(_ content: [String: any PrefStorageValue]) {
        let converted = content.compactMapValues(AnyPrefStorageValue.init(userDefaultsValue:))
        assert(converted.count == content.count)
        self.content = converted
    }
}

extension AnyPrefDictionary: Equatable { }

extension AnyPrefDictionary: Sendable { }

extension AnyPrefDictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, any PrefStorageValue)...) {
        let content = elements.reduce(into: [:]) { partialResult, pair in
            partialResult[pair.0] = AnyPrefStorageValue(pair.1)
        }
        assert(content.count == elements.count)
        self.init(content)
    }
}

// MARK: - Dictionary Proxy Methods

extension AnyPrefDictionary {
    public subscript(_ key: String) -> (any PrefStorageValue)? {
        get {
            content[key]?.value
        }
        _modify {
            var val = content[key]?.value
            yield &val
            if let val {
                guard let typeErased = AnyPrefStorageValue(val) else {
                    assertionFailure()
                    return
                }
                content[key] = typeErased
            } else {
                content[key] = nil
            }
        }
        set {
            if let newValue {
                guard let typeErased = AnyPrefStorageValue(newValue) else {
                    assertionFailure()
                    return
                }
                content[key] = typeErased
            } else {
                content[key] = nil
            }
        }
    }
    
    public var count: Int {
        content.count
    }
}
