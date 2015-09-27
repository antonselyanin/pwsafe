//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Pwsafe {
    // todo: password?
    public let name: String
    public let header: PwsafeRecord<HeaderRecord>
    public let records: [PwsafeRecord<PasswordRecord>]
}

public struct RawField {
    let typeCode: UInt8
    let bytes: [UInt8]
}

public struct FieldKey<RecordType, ValueType> {
    let code: UInt8
    let extractor: (bytes: [UInt8]) -> ValueType?
}

public protocol HeaderRecord {}
public protocol PasswordRecord {}

private func headerKey<T>(code: PwsafeHeaderFieldType, extractor: (bytes: [UInt8]) -> T?) -> FieldKey<HeaderRecord, T> {
    return FieldKey<HeaderRecord, T>(code: code.rawValue, extractor: extractor)
}

public final class HeaderKeys {
    public static let Version = headerKey(.Version, extractor: uint16Extractor)
    public static let UUID = headerKey(.UUID, extractor: uuidExtractor)
    public static let WhatPerformedLastSave = headerKey(.WhatPerformedLastSave, extractor: stringExtractor)
    public static let DatabaseName = headerKey(.DatabaseName, extractor: stringExtractor)
    public static let DatabaseDescription = headerKey(.DatabaseDescription, extractor: stringExtractor)
}

public struct PwsafeRecord<RecordType> {
    public let rawFields: [RawField]
    
    func valueByKey<ValueType>(key: FieldKey<RecordType, ValueType>) -> ValueType? {
        for field in rawFields {
            if field.typeCode == key.code {
                return key.extractor(bytes: field.bytes)
            }
        }
        
        return nil;
    }
}


enum PwsafeHeaderFieldType: UInt8 {
    case Version = 0x00
    case UUID = 0x01
    case NonDefaultPreferences = 0x03
    case TreeDisplayStatus = 0x04
    case WhoPerformedLastSave = 0x05 // deprecated by the specification
    case WhatPerformedLastSave = 0x06
    case LastSavedByUser = 0x07
    case LastSavedOnHost = 0x08
    case DatabaseName = 0x09
    case DatabaseDescription = 0x0a
    case DatabaseFilters = 0x0b
    case Reserved1 = 0x0c
    case Reserved2 = 0x0d
    case Reserved3 = 0x0e
    case RecentlyUsedEntries = 0x0f
    case NamedPasswordPolicies = 0x10
    case EmptyGroups = 0x11
    case Yubico = 0x12
}

enum PwsafeRecordFieldType: UInt8 {
    case UUID = 0x01
}

/*
Currently
Name                        Value        Type    Implemented      Comments
--------------------------------------------------------------------------
UUID                        0x01        UUID          Y              [1]
Group                       0x02        Text          Y              [2]
Title                       0x03        Text          Y
Username                    0x04        Text          Y
Notes                       0x05        Text          Y
Password                    0x06        Text          Y              [3,4]
Creation Time               0x07        time_t        Y              [5]
Password Modification Time  0x08        time_t        Y              [5]
Last Access Time            0x09        time_t        Y              [5,6]
Password Expiry Time        0x0a        time_t        Y              [5,7]
*RESERVED*                  0x0b        4 bytes       -              [8]
Last Modification Time      0x0c        time_t        Y              [5,9]
URL                         0x0d        Text          Y              [10]
Autotype                    0x0e        Text          Y              [11]
Password History            0x0f        Text          Y              [12]
Password Policy             0x10        Text          Y              [13]
Password Expiry Interval    0x11        4 bytes       Y              [14]
Run Command                 0x12        Text          Y
Double-Click Action         0x13        2 bytes       Y              [15]
EMail address               0x14        Text          Y              [16]
Protected Entry             0x15        1 byte        Y              [17]
Own symbols for password    0x16        Text          Y              [18]
Shift Double-Click Action   0x17        2 bytes       Y              [15]
Password Policy Name        0x18        Text          Y              [19]
Entry keyboard shortcut     0x19        4 bytes       Y              [20]
End of Entry                0xff        [empty]       Y              [21]
*/

//public struct PwsafeRecord {
//    public let uuid: NSUUID
//    public let title: String
//    public let password: String
//    
//    public let rawRecords: [RawField]
//}

public enum PwsafeParseError: ErrorType {
    case CorruptedData
}
