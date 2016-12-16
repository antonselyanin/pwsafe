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

public enum Header: RecordType {
    public static let version = key(0x00, ValueSerializers.uint16Values)
    public static let uuid = key(0x01, ValueSerializers.uuids)
    public static let timestampOfLastSave = key(0x04, ValueSerializers.date)
    public static let whatPerformedLastSave = key(0x06, ValueSerializers.strings)
    public static let databaseName = key(0x09, ValueSerializers.strings)
    public static let databaseDescription = key(0x0a, ValueSerializers.strings)
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
    
    public var timestampOfLastSave: Date? {
        get {
            return value(forKey: Header.timestampOfLastSave)
        }
        set {
            setValue(newValue, forKey: Header.timestampOfLastSave)
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
