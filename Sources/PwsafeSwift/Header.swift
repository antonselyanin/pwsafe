//
//  Header.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 27/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

/*
 3.2 Field types for the PasswordSafe database header:
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

public typealias Header = RecordData<HeaderKey>

public enum HeaderKey: RecordType {
    public typealias Key<FieldType> = FieldKey<HeaderKey, FieldType>
    
    public static let uuid: Key<UUID> = key(0x01, ValueSerializers.uuid)

    /// sourcery: type = UInt16
    public static let version: Key<UInt16> = key(0x00, ValueSerializers.uint16Values)

    /// sourcery: type = Date
    public static let timestampOfLastSave: Key<Date> = key(0x04, ValueSerializers.date)

    /// sourcery: type = String
    public static let whatPerformedLastSave: Key<String> = key(0x06, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let databaseName: Key<String> = key(0x09, ValueSerializers.strings)
    
    /// sourcery: type = String
    public static let databaseDescription: Key<String> = key(0x0a, ValueSerializers.strings)
    
    public static let emptyGroups: ListFieldKey<HeaderKey, Group> = listKey(0x11, ValueSerializers.group)
}

extension RecordProtocol where Type == HeaderKey {
    public var emptyGroups: [Group] {
        return values(forKey: HeaderKey.emptyGroups)
    }
    
    public mutating func addEmptyGroup(_ group: Group) {
        add(value: group, forKey: HeaderKey.emptyGroups)
    }

    public mutating func removeEmptyGroup(_ group: Group) {
        remove(value: group, forKey: HeaderKey.emptyGroups)
    }
    
    public mutating func removeAllEmptyGroups() {
        removeAll(forKey: HeaderKey.emptyGroups)
    }
}
