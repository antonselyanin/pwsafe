//
//  CipherBlockMode.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 04/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

typealias CipherOperation = [UInt8] -> [UInt8]?

protocol BlockMode {
    func encryptInput(input: [[UInt8]], iv: [UInt8]?, @noescape cipherOperation: CipherOperation) throws -> [UInt8]

    func decryptInput(input: [[UInt8]], iv: [UInt8]?, @noescape cipherOperation: CipherOperation) throws -> [UInt8]
}

struct ECBMode: BlockMode {
    func encryptInput(input: [[UInt8]], iv: [UInt8]?, @noescape cipherOperation: CipherOperation) throws -> [UInt8] {
        var output = [UInt8]()
        let outputSize = input.count * (input.first?.count ?? 0)
        output.reserveCapacity(outputSize)
        
        for block in input {
            if let encrypted = cipherOperation(block) {
                output.appendContentsOf(encrypted);
            }
        }
        
        return output
    }
    
    func decryptInput(input: [[UInt8]], iv: [UInt8]?, @noescape cipherOperation: CipherOperation) throws -> [UInt8] {
        return try encryptInput(input, iv: iv, cipherOperation: cipherOperation)
    }
}

struct CBCMode: BlockMode {
    //todo: test?
    func encryptInput(input: [[UInt8]], iv: [UInt8]?, @noescape cipherOperation: CipherOperation) throws -> [UInt8] {
        let blockSize = input.first?.count ?? 0
        
        var output = [UInt8]()
        let outputSize = input.count * blockSize
        output.reserveCapacity(outputSize)

        var xorFeed = iv ?? [UInt8](count: blockSize, repeatedValue: 0)
        
        for block in input {
            let xorred = zip(xorFeed, block).map {$0.0 ^ $0.1}
            
            if let encrypted = cipherOperation(xorred) {
                output.appendContentsOf(encrypted)
                xorFeed = encrypted
            }
        }
        
        return output
    }
    
    //todo: test?
    func decryptInput(input: [[UInt8]], iv: [UInt8]?, @noescape cipherOperation: CipherOperation) throws -> [UInt8] {
        let blockSize = input.first?.count ?? 0
        
        var output = [UInt8]()
        let outputSize = input.count * blockSize
        output.reserveCapacity(outputSize)
        
        var xorFeed = iv ?? [UInt8](count: blockSize, repeatedValue: 0)

        for block in input {
            if let decrypted = cipherOperation(block) {
                let xorred = zip(xorFeed, decrypted).map {$0.0 ^ $0.1}
                output.appendContentsOf(xorred)
                xorFeed = block
            }
        }
        
        return output
    }
}