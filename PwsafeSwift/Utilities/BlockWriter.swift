//
//  BlockWriter.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

class BlockWriter {
    fileprivate(set) var data = [UInt8]()
    private let blockSize: Int
    
    init(blockSize: Int = 16) {
        self.blockSize = blockSize
    }
    
    func write(_ bytes: [UInt8]) {
        data.append(contentsOf: bytes)
    }
    
    func write<T: ByteArrayConvertible>(_ value: T) {
        write(value.littleEndianBytes())
    }
    
    func finishBlock() throws {
        let remainder = data.count % blockSize
        if remainder > 0 {
            data.append(contentsOf: try generateRandomBytes(blockSize - remainder))
        }
    }
}

extension BlockWriter {
    func writeRawField(type: UInt8, data: [UInt8] = []) throws {
        write(UInt32(data.count))
        write(type)
        write(data)
        try finishBlock()
    }
}
