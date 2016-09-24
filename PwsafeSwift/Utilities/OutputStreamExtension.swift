//
//  NSOutputStreamExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 18/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension OutputStream {
    //todo: handle errors?
    
    func write(_ data: ByteArrayConvertible) {
        write(data.toLittleEndianBytes())
    }
    
    func write(_ data: [UInt8]) {
        let writtenBytes = write(data, maxLength: data.count)
        assert(writtenBytes == data.count)
    }
}
