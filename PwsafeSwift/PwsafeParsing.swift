//
//  PwsafeParsing.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 20/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import CryptoSwift

public func readPwsafe(data: NSData, password: String) throws -> Pwsafe {
    let stream = NSInputStream(data: data)
    stream.open()
    
    let tag = stream.readBytes(4)!
    
    if "PWS3".utf8Bytes() != tag {
        throw PwsafeParseError.CorruptedData
    }
    
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
    
    let stretchedKey = stretchKey(password.utf8Bytes(),
        salt:salt,
        iterations: Int(iter))
    
    var keyHash: [UInt8] = [UInt8](count: 32, repeatedValue: 0)
    let keyHashData = Hash.sha256(NSData(bytes: stretchedKey)).calculate()!
    keyHashData.getBytes(&keyHash, length: keyHash.count)
    
    if keyHash != passwordHash {
        throw PwsafeParseError.CorruptedData
    }
    
    let recordsKeyCryptor = Twofish(key: stretchedKey, blockMode:CipherBlockMode.ECB)!
    let recordsKey1 = try recordsKeyCryptor.decrypt(b1, padding:nil)
    let recordsKey2 = try recordsKeyCryptor.decrypt(b2, padding:nil)
    let recordsKey = recordsKey1 + recordsKey2
    
    let recordsCryptor = Twofish(key: recordsKey, iv: iv, blockMode:CipherBlockMode.CBC)!
    
    let decryptedData = try recordsCryptor.decrypt(encryptedData, padding: nil)
    
    let header = try! parsePwsafeHeader(decryptedData)
    
    return Pwsafe(name: "", header: header, records: [])
}

func parseRawPwsafeRecords(let data: [UInt8]) throws -> [[RawField]] {
    var reader = BlockReader(data: data)
    var rawRecords = [[RawField]]()
    var rawFields = [RawField]()
    while reader.hasMoreData {
        guard let fieldLength = reader.readUInt32LE() else {
            throw PwsafeParseError.CorruptedData
        }
        
        guard let fieldType = reader.readUInt8() else {
            throw PwsafeParseError.CorruptedData
        }
        
        guard let fieldData = reader.readBytes(Int(fieldLength)) else {
            throw PwsafeParseError.CorruptedData
        }
        
        //todo: magic constant?
        if fieldType == 0xff {
            rawRecords.append(rawFields)
            rawFields = [RawField]()
        } else {
            rawFields.append(RawField(typeCode: fieldType, bytes: fieldData))
        }
        
        reader.nextBlock()
    }
    
    return rawRecords
}

func parsePwsafeHeader(let data: [UInt8]) throws -> PwsafeRecord<HeaderRecord> {
    guard let headerFields = try parseRawPwsafeRecords(data).first else {
        throw PwsafeParseError.CorruptedData
    }
    
    return PwsafeRecord<HeaderRecord>(rawFields: headerFields)
}

func stretchKey(password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
    var resultData = NSData(bytes: password + salt)
    
    for _ in 0...iterations {
        resultData = Hash.sha256(resultData).calculate()!
    }
    
    var bytes: [UInt8] = [UInt8](count: 32, repeatedValue: 0)
    resultData.getBytes(&bytes, length: bytes.count)
    
    return bytes
}

/*
func stretchKeyFast(password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
let inputData = NSMutableData(bytes: password + salt)
var resultData = [UInt8](count:Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)

for _ in 0...iterations {
CC_SHA256(inputData.bytes, UInt32(inputData.length), &resultData)
inputData.replaceBytesInRange(NSMakeRange(0, resultData.count), withBytes: resultData);
inputData.length = resultData.count
}

return resultData
}
*/
