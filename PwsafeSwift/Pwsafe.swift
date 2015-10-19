//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Pwsafe {
    public let header: PwsafeHeaderRecord
    public let passwordRecords: [PwsafePasswordRecord]

    public init() {
        self.init(header: PwsafeHeaderRecord(rawFields: []), passwordRecords: [])
    }

    public init(var header: PwsafeHeaderRecord, passwordRecords: [PwsafePasswordRecord]) {
        if header.uuid == nil {
            header.uuid = NSUUID()
        }
        
        self.header = header
        self.passwordRecords = passwordRecords
    }
}

public struct PwsafeHeaderRecord: PwsafeRecord {
    public var rawFields: [RawField]
    
    public init(rawFields: [RawField]) {
        self.rawFields = rawFields
    }
    
    public init() {
        self.init(rawFields: [])
    }
}

public struct PwsafePasswordRecord: PwsafeRecord {
    public var rawFields: [RawField]

    public init(rawFields: [RawField]) {
        self.rawFields = rawFields
    }
    
    public init() {
        self.init(rawFields: [])
    }
}

public protocol PwsafeRecord: Equatable {
    var rawFields: [RawField] { get set }

    func valueForKey<ValueType>(key: FieldKey<Self, ValueType>) -> ValueType?
    
    mutating func setValue<ValueType>(value: ValueType?, forKey: FieldKey<Self, ValueType>)
}

public extension PwsafeRecord {
    func valueForKey<ValueType>(key: FieldKey<Self, ValueType>) -> ValueType? {
        return rawFields.lazy
            .filter {$0.typeCode == key.code}
            .flatMap {key.fromByteArray(bytes: $0.bytes)}
            .first
    }
    
    mutating func setValue<ValueType>(value: ValueType?, forKey: FieldKey<Self, ValueType>) {
        let index = rawFields.indexOf({$0.typeCode == forKey.code})
        
        if let value = value {
            let newValue = RawField(
                typeCode: forKey.code,
                bytes: forKey.toByteArray(value: value))
            
            if let index = index {
                rawFields[index] = newValue
            } else {
                rawFields.append(newValue)
            }
        } else if let index = index {
            rawFields.removeAtIndex(index)
        }
    }
}

public struct RawField {
    public let typeCode: UInt8
    public let bytes: [UInt8]
    
    public init(typeCode: UInt8, bytes: [UInt8]) {
        self.typeCode = typeCode
        self.bytes = bytes
    }
}

public struct FieldKey<RecordType, ValueType> {
    public let code: UInt8
    public let fromByteArray: (bytes: [UInt8]) -> ValueType?
    public let toByteArray: (value: ValueType) -> [UInt8]
}

extension Pwsafe: Equatable {}
public func ==(lhs: Pwsafe, rhs: Pwsafe) -> Bool {
    return lhs.header == rhs.header
        && lhs.passwordRecords == rhs.passwordRecords
}

public func ==<T: PwsafeRecord>(lhs: T, rhs: T) -> Bool {
    return lhs.rawFields == rhs.rawFields
}

extension RawField: Equatable {}
public func ==(lhs: RawField, rhs: RawField) -> Bool {
    return lhs.typeCode == rhs.typeCode
        && lhs.bytes == rhs.bytes
}
