//
//  PrefsStorageImportStrategy.swift
//  PrefsKit • https://github.com/orchetect/PrefsKit
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol PrefsStorageImportStrategy {
    // MARK: - Atomic Types
    func importValue(forKeyPath keyPath: [String], value: Int) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: String) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: Bool) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: Double) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: Float) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: Data) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: Date) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: [Any]) throws -> PrefsStorageImportResult
    func importValue(forKeyPath keyPath: [String], value: [String: Any]) throws -> PrefsStorageImportResult
    
    // MARK: - Additional Types
    func importValue(forKeyPath keyPath: [String], value: NSNumber) throws -> PrefsStorageImportResult
}

// MARK: - Default Implementation

extension PrefsStorageImportStrategy {
    // MARK: - Atomic Types
    
    public func importValue(forKeyPath keyPath: [String], value: Int) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: String) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: Bool) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: Double) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: Float) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: Data) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: Date) throws -> PrefsStorageImportResult {
        .atomic(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: [Any]) throws -> PrefsStorageImportResult {
        .unsafe(value)
    }

    public func importValue(forKeyPath keyPath: [String], value: [String: Any]) throws -> PrefsStorageImportResult {
        .unsafe(value)
    }
    
    // MARK: - Additional Types
    
    public func importValue(forKeyPath keyPath: [String], value: NSNumber) throws -> PrefsStorageImportResult {
        switch value {
        case let v as Int: .atomic(v)
        case let v as Bool: .atomic(v)
        case let v as Double: .atomic(v)
        case let v as Float: .atomic(v)
        default: .atomic(value)
        }
    }
}
