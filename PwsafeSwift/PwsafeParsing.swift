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
        let pwsafe = try EncryptedPwsafe.read(from: data)
        let pwsafeRecords = try decryptPwsafeRecords(pwsafe, password: password)
        
        guard let headerFields = pwsafeRecords.first else {
            throw PwsafeError.corruptedData
        }
        
        self.header = Header(rawFields: headerFields)
        
        self.records = pwsafeRecords
            .dropFirst()
            .map(Record.init(rawFields:))
    }
}

internal func decryptPwsafeRecords(_ pwsafe: EncryptedPwsafe, password: String) throws -> [[RawField]] {
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

internal func parseRawPwsafeRecords(_ data: [UInt8]) throws -> [[RawField]] {
    guard let result = RawField.allFieldsParser.parse(Data(bytes: data)).value?.value else {
        throw PwsafeError.corruptedData
    }
  
    return result
}

internal func stretchKey(_ password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
    return sha256(password + salt, iterations: iterations)
}

internal func sha256(_ input: [UInt8], iterations: Int = 1) -> [UInt8] {
    //todo: check CC error? status?
    
    var inputData = input
    var resultData = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    
    for _ in 0..<iterations {
        CC_SHA256(inputData, UInt32(inputData.count), &resultData)
        inputData.replaceSubrange(inputData.indices, with: resultData)
    }
    
    return resultData
}

