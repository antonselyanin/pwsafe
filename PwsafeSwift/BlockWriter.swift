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
    
    init() {
        
    }
    
    mutating func write(bytes: [UInt8]) {
        data.appendContentsOf(bytes)
    }
    
    mutating func write<T: ByteArrayConvertible>(value: T) {
        write(value.toLittleEndianBytes())
    }
    
    mutating func finishBlock() {
        let remainder = data.count % BlockSize
        if remainder > 0 {
            let remainderArray = [UInt8](count: BlockSize - remainder, repeatedValue: 0)
            data.appendContentsOf(remainderArray)
        }
    }
}