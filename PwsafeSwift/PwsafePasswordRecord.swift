//
//  PwsafePasswordRecord.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 27/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

/*
3.3 Field types for database Records:
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


public enum PwsafePasswordFieldType: UInt8 {
    case UUID = 0x01
    case Group = 0x02
    case Title = 0x03
    case Username = 0x04
    case Notes = 0x05
    case Password = 0x06
    case CreationTime = 0x07
    case PasswordModificationTime = 0x08
    case LastAccessTime = 0x09
    case PasswordExpiryTime = 0x0a
    case Reserved = 0x0b
    case LastModificationTime = 0x0c
    case URL = 0x0d
    case Autotype = 0x0e
    case PasswordHistory = 0x0f
    case PasswordPolicy = 0x10
    case PasswordExpiryInterval = 0x11
    case RunCommand = 0x12
    case DoubleClickAction = 0x13
    case EmailAddress = 0x14
    case ProtectedEntry = 0x15
    case OwnSymbolsForPassword = 0x16
    case ShiftDoubleClickAction = 0x17
    case PasswordPolicyName = 0x18
    case EntryKeyboardShortcut = 0x19
}

public extension PwsafePasswordRecord {
    public static let UUID = key(.UUID, ValueSerializers.uuids)
    public static let Group = key(.Group, ValueSerializers.strings)
    public static let Title = key(.Title, ValueSerializers.strings)
    public static let Username = key(.Username, ValueSerializers.strings)
    public static let Notes = key(.Notes, ValueSerializers.strings)
    public static let Password = key(.Password, ValueSerializers.strings)
}

public extension PwsafePasswordRecord {
    //todo: clean up
//    public var uuid: NSUUID? {
//        get {
//            return valueForKey(PwsafePasswordRecord.UUID)
//        }
//        set {
//            setValue(newValue, forKey: PwsafePasswordRecord.UUID)
//        }
//    }
    
    public var group: String? {
        get {
            return valueForKey(PwsafePasswordRecord.Group)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.Group)
        }
    }
    
    public var title: String? {
        get {
            return valueForKey(PwsafePasswordRecord.Title)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.Title)
        }
    }
    
    public var username: String? {
        get {
            return valueForKey(PwsafePasswordRecord.Username)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.Username)
        }
    }

    public var notes: String? {
        get {
            return valueForKey(PwsafePasswordRecord.Notes)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.Notes)
        }
    }

    public var password: String? {
        get {
            return valueForKey(PwsafePasswordRecord.Password)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.Password)
        }
    }
}

private func key<Value>
    (code: PwsafePasswordFieldType, _ serializer: ValueSerializer<Value>) -> FieldKey<PwsafePasswordRecord, Value> {
        return FieldKey<PwsafePasswordRecord, Value>(code: code.rawValue, serializer: serializer)
}

