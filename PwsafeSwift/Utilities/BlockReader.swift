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
        get {
            return position < data.count
        }
    }

    init(data: [UInt8], blockSize: Int = 16 ) {
        self.data = data
        self.blockSize = blockSize
    }
    
    mutating func readBytes(count:Int) -> [UInt8]? {
        if position + count > data.count {
            return nil
        }
        
        let result = [UInt8](data[position ..< position + count])
        position += count
        return result
    }
    
    mutating func readUInt32LE() -> UInt32? {
        if let bytes = readBytes(4) {
            return UInt32(littleEndianBytes: bytes)
        }
        
        return nil
    }
    
    mutating func readUInt16LE() -> UInt16? {
        if let bytes = readBytes(2) {
            return UInt16(littleEndianBytes: bytes)
        }
        
        return nil
    }

    mutating func readUInt8() -> UInt8? {
        if let bytes = readBytes(1) {
            return UInt8(bytes[0])
        }
        
        return nil
    }
    
    mutating func nextBlock() -> Bool {
        guard hasMoreData else { return false }
        
        guard position % blockSize != 0 else { return true }
        
        position += blockSize - position % blockSize
        
        if position >= data.count {
            position = data.count
            return false
        }
        
        return true
    }
}