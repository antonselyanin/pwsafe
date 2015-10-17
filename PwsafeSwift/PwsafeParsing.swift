//
//  PwsafeParsing.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 20/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public enum PwsafeParseError: ErrorType {
    case CorruptedData
}

public extension Pwsafe {
    init(data: NSData, password: String) throws {
        let pwsafe = try readEncryptedPwsafe(data)
        let pwsafeRecords = try decryptPwsafeRecords(pwsafe, password: password)
        
        guard let headerFields = pwsafeRecords.first else {
            throw PwsafeParseError.CorruptedData
        }
        
        self.header = PwsafeHeaderRecord(rawFields: headerFields)
        
        self.passwordRecords = pwsafeRecords[1..<pwsafeRecords.count].map {
            PwsafePasswordRecord(rawFields: $0)
        }
    }
}

func decryptPwsafeRecords(pwsafe: EncryptedPwsafe, password: String) throws -> [[RawField]] {
    let stretchedKey = stretchKey(password.utf8Bytes(),
        salt: pwsafe.salt,
        iterations: Int(pwsafe.iter + 1)) // todo: why +1 ?????
    
    let keyHash = sha256(stretchedKey)
    
    if keyHash != pwsafe.passwordHash {
        throw PwsafeParseError.CorruptedData
    }
    
    let recordsKeyCryptor = Twofish(key: stretchedKey, blockMode: ECBMode())!
    let recordsKey = try recordsKeyCryptor.decrypt(pwsafe.b12)
    let hmacKey = try recordsKeyCryptor.decrypt(pwsafe.b34)
    
    let recordsCryptor = Twofish(key: recordsKey, iv: pwsafe.iv, blockMode: CBCMode())!
    
    let decryptedData = try recordsCryptor.decrypt(pwsafe.encryptedData)
    let pwsafeRecords = try parseRawPwsafeRecords(decryptedData)
    
    let hmacer = Hmac(key: hmacKey)
    for field in pwsafeRecords.lazy.flatten() {
        hmacer.update(field.bytes)
    }
    let hmac = hmacer.final()
    
    if hmac != pwsafe.hmac {
        throw PwsafeParseError.CorruptedData
    }
    
    return pwsafeRecords
}

struct EncryptedPwsafe {
    let salt: [UInt8]
    let iter: UInt32
    let passwordHash: [UInt8]
    let b12: [UInt8]
    let b34: [UInt8]
    let iv: [UInt8]
    let encryptedData: [UInt8]
    let hmac: [UInt8]
}

//todo: write tests, clean up
func readEncryptedPwsafe(data: NSData) throws -> EncryptedPwsafe {
    let stream = NSInputStream(data: data)
    stream.open()
    
    let tag = stream.readBytes(4)!
    
    if "PWS3".utf8Bytes() != tag {
        throw PwsafeParseError.CorruptedData
    }
    
    let salt = stream.readBytes(32)!
    let iter = stream.readUInt32LE()!
    let passwordHash = stream.readBytes(32)!
    let b12 = stream.readBytes(32)!
    let b34 = stream.readBytes(32)!
    let iv = stream.readBytes(16)!
    
    let remainder = stream.readAllAvailable()
    let tailLength = "PWS3-EOFPWS3-EOF".characters.count + 32
    
    let encryptedData = [UInt8](remainder[0..<(remainder.count - tailLength)])
    let eof = [UInt8](remainder[encryptedData.count..<(remainder.count - 32)])
    if eof != "PWS3-EOFPWS3-EOF".utf8Bytes() {
        throw PwsafeParseError.CorruptedData
    }
    
    let hmac = [UInt8](remainder[remainder.count - 32 ..< remainder.count])
    
    return EncryptedPwsafe(
        salt: salt,
        iter: iter,
        passwordHash: passwordHash,
        b12: b12, b34: b34,
        iv: iv,
        encryptedData: encryptedData,
        hmac: hmac)
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

func stretchKey(password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
    return sha256(password + salt, iterations: iterations)
}

func sha256(input: [UInt8], iterations: Int = 1) -> [UInt8] {
    //todo: check CC error? status?
    
    var inputData = input
    var resultData = [UInt8](count:Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
    
    for _ in 0..<iterations {
        CC_SHA256(inputData, UInt32(inputData.count), &resultData)
        inputData.replaceRange(inputData.indices, with: resultData)
    }
    
    return resultData
}

