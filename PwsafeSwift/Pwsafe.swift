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

    public init(header: PwsafeHeaderRecord = PwsafeHeaderRecord(uuid: NSUUID()), passwordRecords: [PwsafePasswordRecord] = []) {
        self.header = header
        self.passwordRecords = passwordRecords
    }
    
    public subscript(uuid: NSUUID) -> PwsafePasswordRecord? {
        get {
            return passwordRecords
                .lazy
                .filter {$0.uuid == uuid}
                .first
        }
        
        set(newValue) {
            let index = passwordRecords.indexOf { $0.uuid == uuid }
            
            if let newValue = newValue {
                if let index = index {
                    passwordRecords[index] = newValue
                } else {
                    passwordRecords.append(newValue)
                }
            } else {
                if let index = index {
                    passwordRecords.removeAtIndex(index)
                }
            }
        }
    }
    
    public mutating func addOrUpdateRecord(record: PwsafePasswordRecord) {
        self[record.uuid] = record
    }
}

public protocol PwsafeRecord: Equatable {
    var uuid: NSUUID { get }
    
    func valueForKey<ValueType>(key: FieldKey<Self, ValueType>) -> ValueType?
    
    mutating func setValue<ValueType>(value: ValueType?, forKey: FieldKey<Self, ValueType>)
}

struct FieldsContainer<RecordType> {
    var fields: [RawField]
    
    func valueForKey<ValueType>(key: FieldKey<RecordType, ValueType>) -> ValueType? {
        return fields.lazy
            .filter {$0.typeCode == key.code}
            .flatMap {key.serializer.fromByteArray(bytes: $0.bytes)}
            .first
    }
    
    mutating func setValue<ValueType>(value: ValueType?, forKey: FieldKey<RecordType, ValueType>) {
        let index = fields.indexOf({$0.typeCode == forKey.code})
        
        if let value = value {
            let newValue = RawField(
                typeCode: forKey.code,
                bytes: forKey.serializer.toByteArray(value: value))
            
            if let index = index {
                fields[index] = newValue
            } else {
                fields.append(newValue)
            }
        } else if let index = index {
            fields.removeAtIndex(index)
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
