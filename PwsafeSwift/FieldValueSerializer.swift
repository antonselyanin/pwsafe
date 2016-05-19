//
//  FieldValueSerializer.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public protocol FieldValueSerializer {
    associatedtype Value
    
    func toByteArray(value: Value) -> [UInt8]
    func fromByteArray(array: [UInt8]) -> Value?
}

struct ByteArrayConvertibleSerializer<T: ByteArrayConvertible>: FieldValueSerializer {
    typealias Value = T
    
    func toByteArray(value: T) -> [UInt8] {
        return value.toLittleEndianBytes()
    }
    
    func fromByteArray(array: [UInt8]) -> T? {
        return T(littleEndianBytes: array)
    }
}

struct UUIDSerializer: FieldValueSerializer {
    func toByteArray(value: NSUUID) -> [UInt8] {
        var bytes = [UInt8](count: 16, repeatedValue: 0)
        value.getUUIDBytes(&bytes)
        return bytes
    }
    
    func fromByteArray(array: [UInt8]) -> NSUUID? {
        var bytesArray = array
        
        if bytesArray.count < 16 {
            bytesArray.appendContentsOf([UInt8](count: 16 - array.count, repeatedValue: 0))
        }
        
        return NSUUID(UUIDBytes: bytesArray)
    }
}

public struct StringSerializer: FieldValueSerializer {
    public func toByteArray(value: String) -> [UInt8] {
        return value.utf8Bytes()
    }
    
    public func fromByteArray(array: [UInt8]) -> String? {
        if let str = NSString(bytes: array, length: array.count, encoding: NSUTF8StringEncoding) {
            return String(str)
        }
        
        return nil
    }
}