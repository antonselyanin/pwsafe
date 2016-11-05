//
//  NSInputStreamExtensions.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public extension InputStream {
    func readBytes(_ count:Int) -> [UInt8]? {
        var bytes = [UInt8](repeating: 0, count: count)
        let result = read(&bytes, maxLength: count)
        return (result == count) ? bytes : nil
    }
    
    func readUInt32() -> UInt32? {
        guard let bytes = readBytes(4) else { return nil }

        var result:UInt32 = 0
        result |= UInt32(bytes[0]) << 24
        result |= UInt32(bytes[1]) << 16
        result |= UInt32(bytes[2]) << 8
        result |= UInt32(bytes[3])
        return result
    }
    
    func readUInt32LE() -> UInt32? {
        guard let bytes = readBytes(4) else { return nil }
        
        var result: UInt32 = 0
        result |= UInt32(bytes[3]) << 24
        result |= UInt32(bytes[2]) << 16
        result |= UInt32(bytes[1]) << 8
        result |= UInt32(bytes[0])
        return result
    }

    func readUInt8() -> UInt8? {
        guard let bytes = readBytes(1) else { return nil }
        
        return UInt8(bytes[0])
    }
    
    func readAllAvailable() -> [UInt8] {
        var bytes = [UInt8]()
        var buffer = [UInt8](repeating: 0, count: 1024)
        while hasBytesAvailable {
            let readBytes = read(&buffer, maxLength: buffer.count)
            if readBytes > 0 {
                bytes.append(contentsOf: buffer[0..<readBytes])
            }
        }
        
        return bytes
    }
}
