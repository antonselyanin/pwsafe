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

//todo: rename to PwsafeHeaderFieldCode/PwsafeHeaderField?
enum PwsafeHeaderFieldType: UInt8 {
    case version = 0x00
    case uuid = 0x01
    case nonDefaultPreferences = 0x03
    case treeDisplayStatus = 0x04
    case whoPerformedLastSave = 0x05 // deprecated by the specification
    case whatPerformedLastSave = 0x06
    case lastSavedByUser = 0x07
    case lastSavedOnHost = 0x08
    case databaseName = 0x09
    case databaseDescription = 0x0a
    case databaseFilters = 0x0b
    //case Reserved1 = 0x0c
    //case Reserved2 = 0x0d
    //case Reserved3 = 0x0e
    case recentlyUsedEntries = 0x0f
    case namedPasswordPolicies = 0x10
    case emptyGroups = 0x11
    case yubico = 0x12
}

public struct Header: RecordType {
    private init() {}
    
    public static let uuid = key(.uuid, ValueSerializers.uuids)
    
    public static let version = key(.version, ValueSerializers.uint16Values)
    public static let whatPerformedLastSave = key(.whatPerformedLastSave, ValueSerializers.strings)
    public static let databaseName = key(.databaseName, ValueSerializers.strings)
    public static let databaseDescription = key(.databaseDescription, ValueSerializers.strings)
}

private func key<Value>(_ code: PwsafeHeaderFieldType, _ serializer: ValueSerializer<Value>) -> FieldKey<Header, Value> {
    return FieldKey(code: code.rawValue, serializer: serializer)
}

public extension RecordProtocol where Type == Header {
    public var version: UInt16? {
        get {
            return value(forKey: Header.version)
        }
        set {
            setValue(newValue, forKey: Header.version)
        }
    }
    
    public var databaseName: String? {
        get {
            return value(forKey: Header.databaseName)
        }
        set {
            setValue(newValue, forKey: Header.databaseName)
        }
    }
}
