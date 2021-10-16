//
//  FieldValueSerializer.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

//TODO: use special protocol for serializing?

public struct ValueSerializer<Value> {
    public let toByteArray: (Value) -> [UInt8]
    public let fromByteArray: ([UInt8]) -> Value?
}

public enum ValueSerializers {
    public static let strings: ValueSerializer<String> = ValueSerializer(
        toByteArray: String.toByteArray,
        fromByteArray: String.fromByteArray)

    public static let uuid: ValueSerializer<UUID> = ValueSerializer(
        toByteArray: UUID.toBytes,
        fromByteArray: UUID.init(bytes:))
    
    /*
     
     3.1.3 Time
     Timestamps are stored as 32 bit, little endian, unsigned integers,
     representing the number of seconds since Midnight, January 1, 1970, GMT.
     (This is equivalent to the time_t type on Windows and POSIX. On the
     Macintosh, the value needs to be adjusted by the constant value 2082844800
     to account for the different epoch of its time_t type.)
     Note that future versions of this format may allow time to be
     specified in 64 bits as well.

     */
    
    public static let date: ValueSerializer<Date> = ValueSerializer(
        toByteArray: Date.toByteArray,
        fromByteArray: Date.fromByteArray)
    
    public static let uint16Values: ValueSerializer<UInt16> = ValueSerializers.byteArrayConvertibles()
    
    public static let group: ValueSerializer<Group> = ValueSerializer(
        toByteArray: { (group: Group) -> [UInt8] in
            return group.segments.joined(separator: ".").utf8Bytes()
        },
        fromByteArray: { (bytes: [UInt8]) -> Group? in
            return String.fromByteArray(bytes)
                .map { string in
                    return string.split(separator: ".").map(String.init)
                }
                .map(Group.init(segments:))
        }
    )
    
    public static let bytes: ValueSerializer<[UInt8]> = ValueSerializer(
        toByteArray: { (bytes: [UInt8]) -> [UInt8] in
            return bytes
        },
        fromByteArray: { (bytes: [UInt8]) -> [UInt8]? in
            return bytes
        }
    )
    
    internal static func byteArrayConvertibles<T: ByteArrayConvertible>() -> ValueSerializer<T> {
        return ValueSerializer(
            toByteArray: { $0.littleEndianBytes() },
            fromByteArray: { T(littleEndianBytes: $0) })
    }
}

private extension String {
    static func toByteArray(_ value: String) -> [UInt8] {
        return value.utf8Bytes()
    }

    static func fromByteArray(_ array: [UInt8]) -> String? {
        return String(bytes: array, encoding: .utf8)
    }
}

private extension Date {
    static func toByteArray(_ value: Date) -> [UInt8] {
        let uint32 = UInt32(min(value.timeIntervalSince1970, TimeInterval(UInt32.max)))
        return uint32.littleEndianBytes()
    }
    
    static func fromByteArray(_ array: [UInt8]) -> Date? {
        let seconds = TimeInterval(UInt32(littleEndianBytes: array))
        return Date(timeIntervalSince1970: seconds)
    }
}
