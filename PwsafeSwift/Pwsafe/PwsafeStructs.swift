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
    public let header: PwsafeHeader
    public let records: [PwsafeRecord]
}

public struct RawField {
    let typeCode: UInt8
    let bytes: [UInt8]
}

/*
Currently
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
public struct PwsafeHeader {
    public let version: UInt16
    public let uuid: NSUUID
    
    public let rawRecords: [RawField]
}

public enum PwsafeHeaderFieldType: UInt8 {
    case Version = 0x00
    case UUID = 0x01
    
    case EndOfEntry = 0xff
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

public struct PwsafeRecord {
    public let uuid: NSUUID
    public let title: String
    public let password: String
    
    public let rawRecords: [RawField]
}

public enum PwsafeParseError: ErrorType {
    case CorruptedData
}
