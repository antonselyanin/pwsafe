//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Pwsafe {
    public internal(set) var header: PwsafeHeaderRecord
    public internal(set) var passwordRecords: [PwsafePasswordRecord]

    public init(header: PwsafeHeaderRecord = PwsafeHeaderRecord(uuid: UUID()), passwordRecords: [PwsafePasswordRecord] = []) {
        self.header = header
        self.passwordRecords = passwordRecords
    }
    
    public subscript(uuid: UUID) -> PwsafePasswordRecord? {
        get {
            return passwordRecords
                .lazy
                .filter {$0.uuid as UUID == uuid}
                .first
        }
        
        set(newValue) {
            let index = passwordRecords.index { $0.uuid as UUID == uuid }
            
            if let newValue = newValue {
                if let index = index {
                    passwordRecords[index] = newValue
                } else {
                    passwordRecords.append(newValue)
                }
            } else {
                if let index = index {
                    passwordRecords.remove(at: index)
                }
            }
        }
    }
    
    public mutating func addOrUpdateRecord(_ record: PwsafePasswordRecord) {
        self[record.uuid as UUID] = record
    }
}

public protocol PwsafeRecord: Equatable {
    var uuid: UUID { get }
    
    func valueForKey<ValueType>(_ key: FieldKey<Self, ValueType>) -> ValueType?
    
    mutating func setValue<ValueType>(_ value: ValueType?, forKey: FieldKey<Self, ValueType>)
}

struct FieldsContainer<RecordType> {
    var fields: [RawField]
    
    func valueForKey<ValueType>(_ key: FieldKey<RecordType, ValueType>) -> ValueType? {
        return fields.lazy
            .filter {$0.typeCode == key.code}
            .flatMap {key.serializer.fromByteArray($0.bytes)}
            .first
    }
    
    mutating func setValue<ValueType>(_ value: ValueType?, forKey: FieldKey<RecordType, ValueType>) {
        let index = fields.index(where: {$0.typeCode == forKey.code})
        
        if let value = value {
            let newValue = RawField(
                typeCode: forKey.code,
                bytes: forKey.serializer.toByteArray(value))
            
            if let index = index {
                fields[index] = newValue
            } else {
                fields.append(newValue)
            }
        } else if let index = index {
            fields.remove(at: index)
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

extension Pwsafe: Equatable {}
public func ==(lhs: Pwsafe, rhs: Pwsafe) -> Bool {
    return lhs.header == rhs.header
        && lhs.passwordRecords == rhs.passwordRecords
}

extension RawField: Equatable {}
public func ==(lhs: RawField, rhs: RawField) -> Bool {
    return lhs.typeCode == rhs.typeCode
        && lhs.bytes == rhs.bytes
}
