//
//  BlockReader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

class BlockReader {
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
    
    func readBytes(_ count:Int) -> [UInt8]? {
        guard position + count <= data.count else { return nil }
        
        let result = [UInt8](data[position ..< position + count])
        position += count
        return result
    }
    
    func read<T: ByteArrayConvertible>() -> T? {
        let size = MemoryLayout<T>.size
        guard let bytes = readBytes(size) else { return nil }
        
        return T(littleEndianBytes: bytes)
    }
    
    func readAll() -> [UInt8] {
        return readBytes(data.count - position) ?? []
    }
    
    @discardableResult
    func nextBlock() -> Bool {
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
