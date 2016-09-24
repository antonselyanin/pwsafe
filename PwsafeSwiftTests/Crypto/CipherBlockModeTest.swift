//
//  CipherBlockMode.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 04/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import PwsafeSwift

class CipherBlockModeTest: QuickSpec {
    override func spec() {
        
        func invert(_ input: [UInt8]) -> [UInt8]? {
            return input.map(~)
        }
        
        describe("ECBMode") {
            it("should encrypt") {
                let mode = ECBMode()
                let input: [[UInt8]] = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
                let encrypted = try! mode.encryptInput(input, iv: nil, cipherOperation: invert)
                
                expect(encrypted).to(equal([255, 254, 253, 252, 251, 250, 249, 248, 247]))
                
                let decrypted = try! mode.decryptInput(encrypted.toChunks(3), iv: nil, cipherOperation: invert)
                
                expect(decrypted).to(equal(Array(input.joined())))
            }
        }
    }
}
