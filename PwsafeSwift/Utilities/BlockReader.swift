//
//  BlockReader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

struct BlockReader {
    private let data: [UInt8]
    private var position: Int = 0
    private let blockSize: Int
    
    var hasMoreData: Bool {
        return position < data.count
    }

    init(data: [UInt8], blockSize: Int = 16) {
        self.data = data
        self.blockSize = blockSize
    }
    
    mutating func readBytes(_ count:Int) -> [UInt8]? {
        guard position + count <= data.count else { return nil }
        
        let result = [UInt8](data[position ..< position + count])
        position += count
        return result
    }
    
    mutating func readUInt32LE() -> UInt32? {
        guard let bytes = readBytes(4) else { return nil }
        
        return UInt32(littleEndianBytes: bytes)
    }
    
    mutating func readUInt16LE() -> UInt16? {
        guard let bytes = readBytes(2) else { return nil }
        
        return UInt16(littleEndianBytes: bytes)
    }

    mutating func readUInt8() -> UInt8? {
        guard let bytes = readBytes(1) else { return nil }

        return UInt8(bytes[0])
    }
    
    mutating func nextBlock() -> Bool {
        guard hasMoreData else { return false }
        
        guard position % blockSize != 0 else { return true }
        
        position += blockSize - position % blockSize
        
        guard position < data.count else {
            position = data.count
            return false
        }
        
        return true
    }
}
