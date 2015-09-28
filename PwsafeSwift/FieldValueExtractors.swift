//
//  FieldValueExtractors.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

func uint16Extractor(bytes bytes: [UInt8]) -> UInt16? {
    return UInt16(littleEndianBytes: bytes)
}

func uuidExtractor(bytes bytes: [UInt8]) -> NSUUID? {
    var uuidBytes = bytes
    
    if uuidBytes.count < 16 {
        uuidBytes.appendContentsOf([UInt8](count: 16 - uuidBytes.count, repeatedValue: 0))
    }
    
    return NSUUID(UUIDBytes: uuidBytes)
}

func stringExtractor(bytes bytes: [UInt8]) -> String? {
    if let str = NSString(bytes: bytes, length: bytes.count, encoding: NSUTF8StringEncoding) {
        return String(str)
    }
    
    return nil
}