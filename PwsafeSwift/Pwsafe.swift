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
    
    init(header: PwsafeHeaderRecord, passwordRecords: [PwsafePasswordRecord]) {
        self.header = header
        self.passwordRecords = passwordRecords
    }
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
        return rawFields.lazy
            .filter {$0.typeCode == key.code}
            .flatMap {key.extractor(bytes: $0.bytes)}
            .first
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