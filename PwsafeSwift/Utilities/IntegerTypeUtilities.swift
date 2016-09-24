//
//  IntegerTypesUtilities.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 13/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation


protocol ByteArrayConvertible {
    init(littleEndianBytes bytes: [UInt8])
    func toLittleEndianBytes() -> [UInt8]
}

extension UInt8: ByteArrayConvertible {
    init(littleEndianBytes bytes: [UInt8]) {
        self = bytes.first ?? 0
    }
    
    func toLittleEndianBytes() -> [UInt8] {
        return [self]
    }
}

extension UInt32: ByteArrayConvertible {
    init(littleEndianBytes bytes: [UInt8]) {
        var result: UInt32 = 0
        for byte in bytes.prefix(MemoryLayout<UInt32>.size).reversed() {
            result = result << 8 | UInt32(byte)
        }
        self = result
    }
    
    func toLittleEndianBytes() -> [UInt8] {
        return [
            UInt8(truncatingBitPattern: self),
            UInt8(truncatingBitPattern: self >> 8),
            UInt8(truncatingBitPattern: self >> 16),
            UInt8(truncatingBitPattern: self >> 24)
        ]
    }
}

extension UInt16: ByteArrayConvertible {
    init(littleEndianBytes bytes: [UInt8]) {
        var result: UInt16 = 0
        for byte in bytes.prefix(MemoryLayout<UInt16>.size).reversed() {
            result = result << 8 | UInt16(byte)
        }
        self = result
    }

    func toLittleEndianBytes() -> [UInt8] {
        return [
            UInt8(truncatingBitPattern: self),
            UInt8(truncatingBitPattern: self >> 8)
        ]
    }
}
