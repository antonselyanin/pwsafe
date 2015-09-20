//
//  EncryptedPwsafe.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

//todo: rename to EncryptedPwsafeData?
public struct EncryptedPwsafe {
    //        TAG|SALT|ITER|H(P')|B1|B2|B3|B4|IV|HDR|R1|R2|...|Rn|EOF|HMAC

    public let tag:[UInt8]
    public let salt:[UInt8]
    public let iter:UInt32
    public let passwordHash:[UInt8]
    public let b1:[UInt8]
    public let b2:[UInt8]
    public let b3:[UInt8]
    public let b4:[UInt8]
    public let iv:[UInt8]
    public let encryptedData:[UInt8]
    public let eof:[UInt8]
    public let hmac:[UInt8]
}

public func readPasswordSafe(data: NSData) -> EncryptedPwsafe {
    //todo: replace NSInputStream with a custom class
    let stream = NSInputStream(data: data)
    stream.open()
    
    let tag = stream.readBytes(4)!
    let salt = stream.readBytes(32)!
    let iter = stream.readUInt32LE()!
    let passwordHash = stream.readBytes(32)!
    let b1 = stream.readBytes(16)!
    let b2 = stream.readBytes(16)!
    let b3 = stream.readBytes(16)!
    let b4 = stream.readBytes(16)!
    let iv = stream.readBytes(16)!
    
    let remainder = stream.readAllAvailable()
    let tailLength = "PWS3-EOFPWS3-EOF".characters.count + 32
    
    let encryptedData = [UInt8](remainder[0..<(remainder.count - tailLength)])
    let eof = [UInt8](remainder[encryptedData.count..<(remainder.count - 32)])
    let hmac = [UInt8](remainder[remainder.count - 32 ..< remainder.count])
    
    return EncryptedPwsafe(
        tag: tag,
        salt: salt,
        iter: iter,
        passwordHash: passwordHash,
        b1: b1,
        b2: b2,
        b3: b3,
        b4: b4,
        iv: iv,
        encryptedData: encryptedData,
        eof: eof,
        hmac: hmac)
}