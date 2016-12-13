//
//  FieldValueSerializer.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation


public struct ValueSerializer<Value> {
    public let toByteArray: (Value) -> [UInt8]
    public let fromByteArray: ([UInt8]) -> Value?
}

public enum ValueSerializers {
    public static let strings: ValueSerializer<String> = ValueSerializer(
        toByteArray: stringToByteArray,
        fromByteArray: stringFromByteArray)

    public static let uuids: ValueSerializer<UUID> = ValueSerializer(
        toByteArray: UUID.toBytes,
        fromByteArray: UUID.init(bytes:))
    
    public static let uint16Values: ValueSerializer<UInt16> = ValueSerializer(
        toByteArray: byteArrayConvertiblesToByteArray,
        fromByteArray: byteArrayConvertiblesFromByteArray)
}

private func byteArrayConvertiblesToByteArray<T: ByteArrayConvertible>(_ value: T) -> [UInt8] {
    return value.littleEndianBytes()
}

private func byteArrayConvertiblesFromByteArray<T: ByteArrayConvertible>(_ array: [UInt8]) -> T? {
    return T(littleEndianBytes: array)
}

private func stringToByteArray(_ value: String) -> [UInt8] {
    return value.utf8Bytes()
}

private func stringFromByteArray(_ array: [UInt8]) -> String? {
    return String(bytes: array, encoding: .utf8)
}
