//
//  PwsafeStoring.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 17/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

let keyStretchIterations: UInt32 = 2048

extension Pwsafe {
    public func toData(withPassword password: String) throws -> Data {
        let output = BlockWriter()
        
        let records = [header.rawFields] + self.records.map({ $0.rawFields })
        let encryptedPwsafe = try encryptPwsafeRecords(records, password: password)
        
        output.write(PwsafeFormat.startTag)
        output.write(encryptedPwsafe.salt)
        output.write(encryptedPwsafe.iter)
        output.write(encryptedPwsafe.passwordHash)
        output.write(encryptedPwsafe.b12)
        output.write(encryptedPwsafe.b34)
        output.write(encryptedPwsafe.iv)
        output.write(encryptedPwsafe.encryptedData)
        output.write(PwsafeFormat.endTag)
        output.write(encryptedPwsafe.hmac)
        
        return Data(bytes: output.data)
    }
}

func encryptPwsafeRecords(_ records: [[RawField]], password: String) throws -> EncryptedPwsafe {
    let salt = generateRandomBytes(32)
    let iter: UInt32 = keyStretchIterations
    
    let stretchedKey = stretchKey(password.utf8Bytes(),
        salt: salt,
        iterations: Int(iter + 1)) // todo: why +1 ?????
    
    let keyHash = sha256(stretchedKey)
    
    let recordsKeyCryptor = try Twofish(key: stretchedKey, blockMode: ECBMode())
    let recordsKey = generateRandomBytes(32)
    let b12 = try recordsKeyCryptor.encrypt(recordsKey)
    let hmacKey = generateRandomBytes(32)
    let b34 = try recordsKeyCryptor.encrypt(hmacKey)
    
    let iv = generateRandomBytes(16)
    let recordsCryptor = try Twofish(key: recordsKey, iv: iv, blockMode: CBCMode())
    let encryptedData = try recordsCryptor.encrypt(pwsafeRecordsToBlockData(records))
    
    let hmacer = Hmac(key: hmacKey)
    for field in records.lazy.joined() {
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

func pwsafeRecordsToBlockData(_ records: [[RawField]]) -> [UInt8] {
    let writer = BlockWriter()
    
    for record in records {
        record.forEach {
            writer.writeRawField(type: $0.typeCode, data: $0.bytes)
        }
        writer.writeRawField(type: PwsafeFormat.endRecordTypeCode)
    }
    
    return writer.data
}
