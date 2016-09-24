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
    case uuid = 0x01
    case group = 0x02
    case title = 0x03
    case username = 0x04
    case notes = 0x05
    case password = 0x06
    case creationTime = 0x07
    case passwordModificationTime = 0x08
    case lastAccessTime = 0x09
    case passwordExpiryTime = 0x0a
    case reserved = 0x0b
    case lastModificationTime = 0x0c
    case url = 0x0d
    case autotype = 0x0e
    case passwordHistory = 0x0f
    case passwordPolicy = 0x10
    case passwordExpiryInterval = 0x11
    case runCommand = 0x12
    case doubleClickAction = 0x13
    case emailAddress = 0x14
    case protectedEntry = 0x15
    case ownSymbolsForPassword = 0x16
    case shiftDoubleClickAction = 0x17
    case passwordPolicyName = 0x18
    case entryKeyboardShortcut = 0x19
}

public struct PwsafePasswordRecord: PwsafeRecord {
    public let uuid: Foundation.UUID
    var fields: FieldsContainer<PwsafePasswordRecord>
    
    public init(uuid: Foundation.UUID = Foundation.UUID()) {
        self.uuid = uuid
        self.fields = FieldsContainer(fields: [])
    }
    
    init(rawFields: [RawField]) {
        var fields = FieldsContainer<PwsafePasswordRecord>(fields: rawFields)
        self.uuid = fields.valueForKey(PwsafePasswordRecord.UUID) ?? Foundation.UUID()
        fields.setValue(nil, forKey: PwsafePasswordRecord.UUID)
        self.fields = fields
    }
    
    public func valueForKey<ValueType>(_ key: FieldKey<PwsafePasswordRecord, ValueType>) -> ValueType? {
        return fields.valueForKey(key)
    }
    
    public mutating func setValue<ValueType>(_ value: ValueType?, forKey key: FieldKey<PwsafePasswordRecord, ValueType>) {
        fields.setValue(value, forKey: key)
    }
}

public extension PwsafePasswordRecord {
    public static let UUID = key(.uuid, ValueSerializers.uuids)
    public static let Group = key(.group, ValueSerializers.strings)
    public static let Title = key(.title, ValueSerializers.strings)
    public static let Username = key(.username, ValueSerializers.strings)
    public static let Notes = key(.notes, ValueSerializers.strings)
    public static let Password = key(.password, ValueSerializers.strings)
    public static let URL = key(.url, ValueSerializers.strings)
    public static let Email = key(.emailAddress, ValueSerializers.strings)
}

public extension PwsafePasswordRecord {
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
    
    public var url: String? {
        get {
            return valueForKey(PwsafePasswordRecord.URL)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.URL)
        }
    }
    
    public var email: String? {
        get {
            return valueForKey(PwsafePasswordRecord.Email)
        }
        set {
            setValue(newValue, forKey: PwsafePasswordRecord.Email)
        }
    }
}

extension PwsafePasswordRecord: Equatable {}
public func ==(lhs: PwsafePasswordRecord, rhs: PwsafePasswordRecord) -> Bool {
    return lhs.uuid == rhs.uuid
        && lhs.fields.fields == rhs.fields.fields
}

private func key<Value>
    (_ code: PwsafePasswordFieldType, _ serializer: ValueSerializer<Value>) -> FieldKey<PwsafePasswordRecord, Value> {
        return FieldKey(code: code.rawValue, serializer: serializer)
}

