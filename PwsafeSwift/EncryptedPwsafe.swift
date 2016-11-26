//
//  EncryptedPwsafe.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 26/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

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

extension EncryptedPwsafe {
    static let parser: Parser<EncryptedPwsafe> =
        curry(EncryptedPwsafe.init)
            <^> Parsers.expect(PwsafeFormat.startTag)
            *> Parsers.read(32).bytes // salt
            <*> Parsers.read() // iter
            <*> Parsers.read(32).bytes // passwordHash
            <*> Parsers.read(32).bytes // b12
            <*> Parsers.read(32).bytes // b34
            <*> Parsers.read(16).bytes // IV
            <*> Parsers.readAll(leave: 32) // encryptedData
                .cut(requiredSuffix: PwsafeFormat.endTag) // eof
                .bytes
            <*> Parsers.read(32).bytes // HMAC
    
    //TODO: write tests
    static func read(from data: Data) throws -> EncryptedPwsafe {
        guard let encrypted = EncryptedPwsafe.parser.parse(data)?.parsed else {
            throw PwsafeError.corruptedData
        }
        
        return encrypted
    }
}
