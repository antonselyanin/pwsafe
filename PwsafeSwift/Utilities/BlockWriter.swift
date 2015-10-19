//
//  BlockWriter.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

private let BlockSize = 16

struct BlockWriter {
    private(set) var data = [UInt8]()
    
    mutating func write(bytes: [UInt8]) {
        data.appendContentsOf(bytes)
    }
    
    mutating func write<T: ByteArrayConvertible>(value: T) {
        write(value.toLittleEndianBytes())
    }
    
    mutating func finishBlock() {
        let remainder = data.count % BlockSize
        if remainder > 0 {
            data.appendContentsOf(generateRandomBytes(BlockSize - remainder))
        }
    }
}

extension BlockWriter {
    mutating func writeRawField(type type: UInt8, data: [UInt8] = []) {
        write(UInt32(data.count))
        write(type)
        write(data)
        finishBlock()
    }
}