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

public enum Password: RecordType {
    
    public static let uuid: FieldKey<Password, UUID> = key(0x01, ValueSerializers.uuid)
    
    /// sourcery: type = String
    public static let group: FieldKey<Password, String> = key(0x02, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let title: FieldKey<Password, String> = key(0x03, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let username: FieldKey<Password, String> = key(0x04, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let notes: FieldKey<Password, String> = key(0x05, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let password: FieldKey<Password, String> = key(0x06, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let url: FieldKey<Password, String> = key(0x0d, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let email: FieldKey<Password, String> = key(0x14, ValueSerializers.strings)
}
