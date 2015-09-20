//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import CryptoSwift

public struct RawField {
    let typeCode: UInt8
    let bytes: [UInt8]
}

public enum PwsafeHeaderFieldType: UInt8 {
    case Version = 0x00
    case UUID = 0x01
    
    case EndOfEntry = 0xff

//    Non-default preferences     0x02        Text          Y              [3]
//    Tree Display Status         0x03        Text          Y              [4]
//    Timestamp of last save      0x04        time_t        Y              [5]
//    Who performed last save     0x05        Text          Y   [DEPRECATED 6]
//    What performed last save    0x06        Text          Y              [7]
//    Last saved by user          0x07        Text          Y              [8]
//    Last saved on host          0x08        Text          Y              [9]
//    Database Name               0x09        Text          Y              [10]
//    Database Description        0x0a        Text          Y              [11]
//    Database Filters            0x0b        Text          Y              [12]
//    Reserved                    0x0c        -                            [13]
//    Reserved                    0x0d        -                            [13]
//    Reserved                    0x0e        -                            [13]
//    Recently Used Entries       0x0f        Text                         [14]
//    Named Password Policies     0x10        Text                         [15]
//    Empty Groups                0x11        Text                         [16]
//    Yubico                      0x12        Text                         [13]
//    End of Entry                0xff        [empty]       Y              [17]

}

public struct PwsafeHeader {
    public let version: UInt16
    public let uuid: NSUUID
    
    public let rawRecords: [RawField]
}

public enum PwsafeHeaderParseError: ErrorType {
    case CorruptedData
}

func parseRawPwsafeRecords(var reader: BlockReader) throws -> [[RawField]] {
    var rawRecords = [[RawField]]()

    var rawFields = [RawField]()
    
    while reader.hasMoreData {
        guard let fieldLength = reader.readUInt32LE() else {
            throw PwsafeHeaderParseError.CorruptedData
        }
        
        guard let fieldType = reader.readUInt8() else {
            throw PwsafeHeaderParseError.CorruptedData
        }
        
        guard let fieldData = reader.readBytes(Int(fieldLength)) else {
            throw PwsafeHeaderParseError.CorruptedData
        }
        
        if fieldType == PwsafeHeaderFieldType.EndOfEntry.rawValue {
            rawRecords.append(rawFields)
            rawFields = [RawField]()
        } else {
            rawFields.append(RawField(typeCode: fieldType, bytes: fieldData))
        }
        
        reader.nextBlock()
    }
    
    return rawRecords
}

func parsePwsafeHeader(reader: BlockReader) throws -> PwsafeHeader {
    var version: UInt16?
    var uuid: NSUUID?
    
    guard let headerFields = try parseRawPwsafeRecords(reader).first else {
        throw PwsafeHeaderParseError.CorruptedData
    }
    
    for record in headerFields {
        switch record.typeCode {
        case PwsafeHeaderFieldType.Version.rawValue:
            version = UInt16(littleEndianBytes: record.bytes)
        case PwsafeHeaderFieldType.UUID.rawValue:
            uuid = NSUUID(UUIDBytes: record.bytes)
        default:
            break;
        }
    }
    
    if let version = version, let uuid = uuid {
        return PwsafeHeader(version: version, uuid: uuid, rawRecords: headerFields)
    }
    
    throw PwsafeHeaderParseError.CorruptedData
}