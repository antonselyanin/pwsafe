//
//  NSInputStreamExtensions.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public extension NSInputStream {
    func readBytes(count:Int) -> [UInt8]? {
        var bytes = [UInt8](count: count, repeatedValue: 0)
        let result = read(&bytes, maxLength: count)
        return (result == count) ? bytes : nil
    }
    
    func readUInt32() -> UInt32? {
        if let bytes = readBytes(4) {
            var result:UInt32 = 0;
            result |= UInt32(bytes[0]) << 24
            result |= UInt32(bytes[1]) << 16
            result |= UInt32(bytes[2]) << 8
            result |= UInt32(bytes[3])
            return result
        }
        
        return nil;
    }
    
    func readUInt32LE() -> UInt32? {
        if let bytes = readBytes(4) {
            var result:UInt32 = 0;
            result |= UInt32(bytes[3]) << 24
            result |= UInt32(bytes[2]) << 16
            result |= UInt32(bytes[1]) << 8
            result |= UInt32(bytes[0])
            return result
        }
        
        return nil;
    }
    
    func readUInt8() -> UInt8? {
        if let bytes = readBytes(1) {
            return UInt8(bytes[0])
        }
        
        return nil;
    }
    
    func readAllAvailable() -> [UInt8] {
        var bytes = [UInt8]()
        var buffer = [UInt8](count: 1024, repeatedValue: 0)
        while (hasBytesAvailable) {
            let readBytes = read(&buffer, maxLength: buffer.count)
            if readBytes > 0 {
                bytes.appendContentsOf(buffer[0..<readBytes])
            }
        }
        
        return bytes
    }
}