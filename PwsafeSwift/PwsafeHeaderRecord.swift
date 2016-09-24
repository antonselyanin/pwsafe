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

public struct PwsafeHeaderRecord: PwsafeRecord {
    public let uuid: Foundation.UUID
    var fields: FieldsContainer<PwsafeHeaderRecord>
    
    public init(uuid: Foundation.UUID = Foundation.UUID()) {
        self.uuid = uuid
        self.fields = FieldsContainer(fields: [])
    }
    
    init(rawFields: [RawField] = []) {
        var fields = FieldsContainer<PwsafeHeaderRecord>(fields: rawFields)
        self.uuid = fields.valueForKey(PwsafeHeaderRecord.UUID) ?? Foundation.UUID()
        fields.setValue(nil, forKey: PwsafeHeaderRecord.UUID)
        self.fields = fields
    }
    
    public func valueForKey<ValueType>(_ key: FieldKey<PwsafeHeaderRecord, ValueType>) -> ValueType? {
        return fields.valueForKey(key)
    }
    
    public mutating func setValue<ValueType>(_ value: ValueType?, forKey key: FieldKey<PwsafeHeaderRecord, ValueType>) {
        fields.setValue(value, forKey: key)
    }
}

public extension PwsafeHeaderRecord {
    public static let Version = key(.version, ValueSerializers.uint16Values)
    public static let UUID = key(.uuid, ValueSerializers.uuids)
    public static let WhatPerformedLastSave = key(.whatPerformedLastSave, ValueSerializers.strings)
    public static let DatabaseName = key(.databaseName, ValueSerializers.strings)
    public static let DatabaseDescription = key(.databaseDescription, ValueSerializers.strings)
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
    
    public var databaseName: String? {
        get {
            return valueForKey(PwsafeHeaderRecord.DatabaseName)
        }
        set {
            setValue(newValue, forKey: PwsafeHeaderRecord.DatabaseName)
        }
    }
}

extension PwsafeHeaderRecord: Equatable {}
public func ==(lhs: PwsafeHeaderRecord, rhs: PwsafeHeaderRecord) -> Bool {
    return lhs.uuid == rhs.uuid
        && lhs.fields.fields == rhs.fields.fields
}

private func key<Value>(_ code: PwsafeHeaderFieldType, _ serializer: ValueSerializer<Value>) -> FieldKey<PwsafeHeaderRecord, Value> {
    return FieldKey(code: code.rawValue, serializer: serializer)
}

