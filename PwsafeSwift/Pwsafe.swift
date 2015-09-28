//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Pwsafe {
    public let name: String
    public let header: PwsafeHeaderRecord
    public let passwordRecords: [PwsafePasswordRecord]
}

public struct PwsafePasswordRecord: PwsafeRecord {
    public let rawFields: [RawField]
}

public struct PwsafeHeaderRecord: PwsafeRecord {
    public let rawFields: [RawField]
}

public protocol PwsafeRecord {
    var rawFields: [RawField] { get }
    func valueByKey<ValueType>(key: FieldKey<Self, ValueType>) -> ValueType?
}


public extension PwsafeRecord {
    func valueByKey<ValueType>(key: FieldKey<Self, ValueType>) -> ValueType? {
        for field in rawFields {
            if field.typeCode == key.code {
                return key.extractor(bytes: field.bytes)
            }
        }
        
        return nil;
    }
}

public struct RawField {
    public let typeCode: UInt8
    public let bytes: [UInt8]
}

public struct FieldKey<RecordType, ValueType> {
    public let code: UInt8
    public let extractor: (bytes: [UInt8]) -> ValueType?
}