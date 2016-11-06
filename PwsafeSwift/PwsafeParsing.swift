//
//  PwsafeParsing.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 20/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

enum PwsafeFormat {
    static let startTag = "PWS3".utf8Bytes()
    static let endTag = "PWS3-EOFPWS3-EOF".utf8Bytes()
    static let endRecordTypeCode: UInt8 = 0xff
}

public extension Pwsafe {
    init(data: Data, password: String) throws {
        let pwsafe = try readEncryptedPwsafe(data)
        let pwsafeRecords = try decryptPwsafeRecords(pwsafe, password: password)
        
        guard let headerFields = pwsafeRecords.first else {
            throw PwsafeError.corruptedData
        }
        
        self.header = HeaderRecord(rawFields: headerFields)
        
        self.passwordRecords = pwsafeRecords[1..<pwsafeRecords.count]
            .map(PasswordRecord.init(rawFields:))
    }
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
func readEncryptedPwsafe(_ data: Data) throws -> EncryptedPwsafe {
    let bytes = data.withUnsafeBytes {
        [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
    }
    
    let stream = BlockReader(data: bytes)
    
    let tag = stream.readBytes(4)!
    
    guard PwsafeFormat.startTag == tag else {
        throw PwsafeError.corruptedData
    }
    
    let salt = stream.readBytes(32)!
    let iter: UInt32 = stream.read()!
    let passwordHash = stream.readBytes(32)!
    let b12 = stream.readBytes(32)!
    let b34 = stream.readBytes(32)!
    let iv = stream.readBytes(16)!
    
    let remainder = stream.readAll()
    let tailLength = PwsafeFormat.endTag.count + 32
    
    let encryptedData = [UInt8](remainder[0..<(remainder.count - tailLength)])
    let eof = [UInt8](remainder[encryptedData.count..<(remainder.count - 32)])
    
    guard PwsafeFormat.endTag == eof else {
        throw PwsafeError.corruptedData
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

func decryptPwsafeRecords(_ pwsafe: EncryptedPwsafe, password: String) throws -> [[RawField]] {
    let stretchedKey = stretchKey(password.utf8Bytes(),
        salt: pwsafe.salt,
        iterations: Int(pwsafe.iter + 1)) // todo: why +1 ?????
    
    let keyHash = sha256(stretchedKey)
    
    guard keyHash == pwsafe.passwordHash else {
        throw PwsafeError.corruptedData
    }
    
    let recordsKeyCryptor = try Twofish(key: stretchedKey, blockMode: ECBMode())
    let recordsKey = try recordsKeyCryptor.decrypt(pwsafe.b12)
    let hmacKey = try recordsKeyCryptor.decrypt(pwsafe.b34)
    
    let recordsCryptor = try Twofish(key: recordsKey, iv: pwsafe.iv, blockMode: CBCMode())
    
    let decryptedData = try recordsCryptor.decrypt(pwsafe.encryptedData)
    let pwsafeRecords = try parseRawPwsafeRecords(decryptedData)
    
    let hmacer = Hmac(key: hmacKey)
    for field in pwsafeRecords.joined() {
        hmacer.update(field.bytes)
    }
    let hmac = hmacer.final()
    
    guard hmac == pwsafe.hmac else {
        throw PwsafeError.corruptedData
    }
    
    return pwsafeRecords
}

func parseRawPwsafeRecords(_ data: [UInt8]) throws -> [[RawField]] {
    let reader = BlockReader(data: data)
    var rawRecords = [[RawField]]()
    var rawFields = [RawField]()
    while reader.hasMoreData {
        guard let fieldLength: UInt32 = reader.read(),
            let fieldType: UInt8 = reader.read(),
            let fieldData = reader.readBytes(Int(fieldLength)) else {
            throw PwsafeError.corruptedData
        }
        
        if fieldType == PwsafeFormat.endRecordTypeCode {
            rawRecords.append(rawFields)
            rawFields = [RawField]()
        } else {
            rawFields.append(RawField(typeCode: fieldType, bytes: fieldData))
        }
        
        reader.nextBlock()
    }
    
    return rawRecords
}

func stretchKey(_ password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
    return sha256(password + salt, iterations: iterations)
}

func sha256(_ input: [UInt8], iterations: Int = 1) -> [UInt8] {
    //todo: check CC error? status?
    
    var inputData = input
    var resultData = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    
    for _ in 0..<iterations {
        CC_SHA256(inputData, UInt32(inputData.count), &resultData)
        inputData.replaceSubrange(inputData.indices, with: resultData)
    }
    
    return resultData
}

