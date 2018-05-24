//
//  CipherBlockMode.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 04/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

typealias CipherOperation = ([UInt8]) -> [UInt8]?

protocol BlockMode {
    func encryptInput(_ input: [[UInt8]], iv: [UInt8]?, cipherOperation: CipherOperation) -> [UInt8]

    func decryptInput(_ input: [[UInt8]], iv: [UInt8]?, cipherOperation: CipherOperation) -> [UInt8]
}

struct ECBMode: BlockMode {
    func encryptInput(_ input: [[UInt8]], iv: [UInt8]?, cipherOperation: CipherOperation) -> [UInt8] {
        var output = [UInt8]()
        let outputSize = input.count * (input.first?.count ?? 0)
        output.reserveCapacity(outputSize)
        
        for block in input {
            if let encrypted = cipherOperation(block) {
                output.append(contentsOf: encrypted);
            }
        }
        
        return output
    }
    
    func decryptInput(_ input: [[UInt8]], iv: [UInt8]?, cipherOperation: CipherOperation) -> [UInt8] {
        return encryptInput(input, iv: iv, cipherOperation: cipherOperation)
    }
}

struct CBCMode: BlockMode {
    //todo: test?
    func encryptInput(_ input: [[UInt8]], iv: [UInt8]?, cipherOperation: CipherOperation) -> [UInt8] {
        let blockSize = input.first?.count ?? 0
        
        var output = [UInt8]()
        let outputSize = input.count * blockSize
        output.reserveCapacity(outputSize)

        var xorFeed = iv ?? [UInt8](repeating: 0, count: blockSize)
        
        for block in input {
            let xorred = zip(xorFeed, block).map {$0.0 ^ $0.1}
            
            if let encrypted = cipherOperation(xorred) {
                output.append(contentsOf: encrypted)
                xorFeed = encrypted
            }
        }
        
        return output
    }
    
    //todo: test?
    func decryptInput(_ input: [[UInt8]], iv: [UInt8]?, cipherOperation: CipherOperation) -> [UInt8] {
        let blockSize = input.first?.count ?? 0
        
        var output = [UInt8]()
        let outputSize = input.count * blockSize
        output.reserveCapacity(outputSize)
        
        var xorFeed = iv ?? [UInt8](repeating: 0, count: blockSize)

        for block in input {
            if let decrypted = cipherOperation(block) {
                let xorred = zip(xorFeed, decrypted).map {$0.0 ^ $0.1}
                output.append(contentsOf: xorred)
                xorFeed = block
            }
        }
        
        return output
    }
}
