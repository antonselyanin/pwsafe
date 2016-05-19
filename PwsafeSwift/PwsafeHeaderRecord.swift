//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 27/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

/*
3.2 Field types for the PasswordSafe database header:
Name                        Value        Type    Implemented      Comments
--------------------------------------------------------------------------
Version                     0x00        2 bytes       Y              [1]
UUID                        0x01        UUID          Y              [2]
Non-default preferences     0x02        Text          Y              [3]
Tree Display Status         0x03        Text          Y              [4]
Timestamp of last save      0x04        time_t        Y              [5]
Who performed last save     0x05        Text          Y   [DEPRECATED 6]
What performed last save    0x06        Text          Y              [7]
Last saved by user          0x07        Text          Y              [8]
Last saved on host          0x08        Text          Y              [9]
Database Name               0x09        Text          Y              [10]
Database Description        0x0a        Text          Y              [11]
Database Filters            0x0b        Text          Y              [12]
Reserved                    0x0c        -                            [13]
Reserved                    0x0d        -                            [13]
Reserved                    0x0e        -                            [13]
Recently Used Entries       0x0f        Text                         [14]
Named Password Policies     0x10        Text                         [15]
Empty Groups                0x11        Text                         [16]
Yubico                      0x12        Text                         [13]
End of Entry                0xff        [empty]       Y              [17]
*/

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
    //case Reserved1 = 0x0c
    //case Reserved2 = 0x0d
    //case Reserved3 = 0x0e
    case RecentlyUsedEntries = 0x0f
    case NamedPasswordPolicies = 0x10
    case EmptyGroups = 0x11
    case Yubico = 0x12
}

public extension PwsafeHeaderRecord {
    public static let Version = key(.Version, ByteArrayConvertibleSerializer<UInt16>())
    public static let UUID = key(.UUID, UUIDSerializer())
    public static let WhatPerformedLastSave = key(.WhatPerformedLastSave, StringSerializer())
    public static let DatabaseName = key(.DatabaseName, StringSerializer())
    public static let DatabaseDescription = key(.DatabaseDescription, StringSerializer())
}

public extension PwsafeHeaderRecord {
    public var version: UInt16? {
        get {
            return valueForKey(PwsafeHeaderRecord.Version)
        }
        set {
            setValue(newValue, forKey: PwsafeHeaderRecord.Version)
        }
    }
    
    //todo: clean up
//    public var uuid: NSUUID? {
//        get {
//            return valueForKey(PwsafeHeaderRecord.UUID)
//        }
//        set {
//            setValue(newValue, forKey: PwsafeHeaderRecord.UUID)
//        }
//    }
    
    public var databaseName: String? {
        get {
            return valueForKey(PwsafeHeaderRecord.DatabaseName)
        }
        set {
            setValue(newValue, forKey: PwsafeHeaderRecord.DatabaseName)
        }
    }
}

private func key<T, S: FieldValueSerializer where S.Value == T>
    (code: PwsafeHeaderFieldType, _ serializer: S) -> FieldKey<PwsafeHeaderRecord, T> {
    return FieldKey<PwsafeHeaderRecord, T>(
        code: code.rawValue,
        fromByteArray: serializer.fromByteArray,
        toByteArray: serializer.toByteArray)
}

