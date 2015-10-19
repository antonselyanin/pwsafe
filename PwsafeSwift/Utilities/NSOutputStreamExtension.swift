//
//  NSOutputStreamExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 18/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension NSOutputStream {
    //todo: handle errors?
    
    func write(data: ByteArrayConvertible) {
        write(data.toLittleEndianBytes())
    }
    
    func write(data: [UInt8]) {
        let writtenBytes = write(data, maxLength: data.count)
        assert(writtenBytes == data.count)
    }
}