//
//  PwsafeStoring.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 17/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension Pwsafe {
    public func toData(withPassword password: String) throws -> NSData {
        let output = NSOutputStream.outputStreamToMemory()
        output.open()
        
        let records = [header.rawFields] + passwordRecords.map {$0.rawFields}
        let encryptedPwsafe = try encryptPwsafeRecords(records, password: password)
        
        output.write(PwsafeStartTag.utf8Bytes())
        output.write(encryptedPwsafe.salt)
        output.write(encryptedPwsafe.iter)
        output.write(encryptedPwsafe.passwordHash)
        output.write(encryptedPwsafe.b12)
        output.write(encryptedPwsafe.b34)
        output.write(encryptedPwsafe.iv)
        output.write(encryptedPwsafe.encryptedData)
        output.write(PwsafeEndTag.utf8Bytes())
        output.write(encryptedPwsafe.hmac)
        
        guard let data = output.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as? NSData else {
            throw PwsafeError.InternalError
        }
        
        return data
    }
}


func encryptPwsafeRecords(records: [[RawField]], password: String) throws -> EncryptedPwsafe {
    let salt = generateRandomBytes(32)
    let iter: UInt32 = 2048
    
    let stretchedKey = stretchKey(password.utf8Bytes(),
        salt: salt,
        iterations: Int(iter + 1)) // todo: why +1 ?????
    
    let keyHash = sha256(stretchedKey)
    
    let recordsKeyCryptor = Twofish(key: stretchedKey, blockMode: ECBMode())!
    let recordsKey = generateRandomBytes(32)
    let b12 = try recordsKeyCryptor.encrypt(recordsKey)
    let hmacKey = generateRandomBytes(32)
    let b34 = try recordsKeyCryptor.encrypt(hmacKey)
    
    let iv = generateRandomBytes(16)
    let recordsCryptor = Twofish(key: recordsKey, iv: iv, blockMode: CBCMode())!
    let encryptedData = try recordsCryptor.encrypt(pwsafeRecordsToBlockData(records))
    
    let hmacer = Hmac(key: hmacKey)
    for field in records.lazy.flatten() {
        hmacer.update(field.bytes)
    }
    let hmac = hmacer.final()
    
    return EncryptedPwsafe(
        salt: salt,
        iter: iter,
        passwordHash: keyHash,
        b12: b12, b34: b34,
        iv: iv,
        encryptedData: encryptedData,
        hmac: hmac)
}

func pwsafeRecordsToBlockData(records: [[RawField]]) -> [UInt8] {
    var blockWriter = BlockWriter()
    
    for record in records {
        for field in record {
            blockWriter.writeRawField(type: field.typeCode, data: field.bytes)
        }
        blockWriter.writeRawField(type: PwsafeEndRecordTypeCode)
    }
    
    return blockWriter.data
}