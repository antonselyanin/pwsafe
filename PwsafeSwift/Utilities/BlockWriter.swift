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
    fileprivate(set) var data = [UInt8]()
    
    mutating func write(_ bytes: [UInt8]) {
        data.append(contentsOf: bytes)
    }
    
    mutating func write<T: ByteArrayConvertible>(_ value: T) {
        write(value.toLittleEndianBytes())
    }
    
    mutating func finishBlock() {
        let remainder = data.count % BlockSize
        if remainder > 0 {
            data.append(contentsOf: generateRandomBytes(BlockSize - remainder))
        }
    }
}

extension BlockWriter {
    mutating func writeRawField(type: UInt8, data: [UInt8] = []) {
        write(UInt32(data.count))
        write(type)
        write(data)
        finishBlock()
    }
}
