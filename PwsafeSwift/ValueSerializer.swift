//
//  FieldValueSerializer.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation


public struct ValueSerializer<Value> {
    let toByteArray: (value: Value) -> [UInt8]
    let fromByteArray: (bytes: [UInt8]) -> Value?
}

public enum ValueSerializers {
    public static let strings: ValueSerializer<String> = ValueSerializer<String>(
        toByteArray: stringToByteArray,
        fromByteArray: stringFromByteArray)

    public static let uuids: ValueSerializer<NSUUID> = ValueSerializer<NSUUID>(
        toByteArray: uuidToByteArray,
        fromByteArray: uuidFromByteArray)
    
    public static let uint16Values: ValueSerializer<UInt16> = ValueSerializer<UInt16>(
        toByteArray: byteArrayConvertiblesToByteArray,
        fromByteArray: byteArrayConvertiblesFromByteArray)
}

private func byteArrayConvertiblesToByteArray<T: ByteArrayConvertible>(value: T) -> [UInt8] {
    return value.toLittleEndianBytes()
}

private func byteArrayConvertiblesFromByteArray<T: ByteArrayConvertible>(array: [UInt8]) -> T? {
    return T(littleEndianBytes: array)
}

private func uuidToByteArray(value: NSUUID) -> [UInt8] {
    var bytes = [UInt8](count: 16, repeatedValue: 0)
    value.getUUIDBytes(&bytes)
    return bytes
}

private func uuidFromByteArray(array: [UInt8]) -> NSUUID? {
    var bytesArray = array
    
    if bytesArray.count < 16 {
        bytesArray.appendContentsOf([UInt8](count: 16 - array.count, repeatedValue: 0))
    }
    
    return NSUUID(UUIDBytes: bytesArray)
}

private func stringToByteArray(value: String) -> [UInt8] {
    return value.utf8Bytes()
}

private func stringFromByteArray(array: [UInt8]) -> String? {
    if let str = NSString(bytes: array, length: array.count, encoding: NSUTF8StringEncoding) {
        return String(str)
    }
    
    return nil
}
