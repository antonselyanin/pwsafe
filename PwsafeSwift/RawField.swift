//
//  RawField.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 05/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public struct RawField {
    public let typeCode: UInt8
    public let bytes: [UInt8]
    
    public init(typeCode: UInt8, bytes: [UInt8]) {
        self.typeCode = typeCode
        self.bytes = bytes
    }
}

extension RawField {
    static let allFieldsParser: Parser<[[RawField]]> = RawField
        .parser
        .aligned(blockSize: 16)
        .many
        .map(RawField.splitByEndOfRecord)
    
    static let parser: Parser<RawField> = Parser { input in
        let p = curry(RawField.read)
            <^> Parsers.read() // length
            <*> Parsers.read() // type
            <*> Parsers.readAll().bytes // data
        
        //recursive generics are not supported, this could be a generic method in ParserProtocol
        return p.parse(input).flatMap { metaResult in
            return metaResult.value
        }
    }
    
    private static func isEndRecord(_ field: RawField) -> Bool {
        return field.typeCode == PwsafeFormat.endRecordTypeCode
    }
    
    private static func splitByEndOfRecord(_ fields: [RawField]) -> [[RawField]] {
        return fields.split(whereSeparator: RawField.isEndRecord).map(Array.init)
    }
    
    private static func read(length: UInt32, type: UInt8, data: [UInt8]) -> ParserResult<RawField> {
        guard data.count >= Int(length) else { return .failure(ParserError.error) }
        
        let remainder = Data(bytes: data.suffix(from: Int(length)))
        let parsed = RawField(typeCode: type, bytes: Array(data.prefix(Int(length))))
        
        return .success(Parsed(remainder: remainder, value: parsed))
    }
}

extension RawField: Equatable {}
public func ==(lhs: RawField, rhs: RawField) -> Bool {
    return lhs.typeCode == rhs.typeCode
        && lhs.bytes == rhs.bytes
}
