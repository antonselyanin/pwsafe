//
//  FieldValueExtractorsTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import PwsafeSwift

class FieldValueSerializersTest: QuickSpec {
    override func spec() {
        describe("uuidExtractor") {
            it("should extract UUID from bytes") {
                let extracted = uuidExtractor(bytes: [UInt8](count: 16, repeatedValue: 0x12))
                let expected = NSUUID(UUIDString: "12121212-1212-1212-1212-121212121212")
                expect(extracted).to(equal(expected))
            }
            
            it("should fill with zeros if not enough bytes") {
                let extracted = uuidExtractor(bytes: [UInt8](count: 4, repeatedValue: 0x12))
                let expected = NSUUID(UUIDString: "12121212-0000-0000-0000-000000000000")
                expect(extracted).to(equal(expected))
            }
        }
        
        describe("stringExtractor") {
            it("should create from utf8 bytes") {
                let testString = "test string 😎"
                let bytes = testString.utf8Bytes()
                let extracted = stringExtractor(bytes: bytes)
                expect(extracted).to(equal(testString))
            }
        }
    }
}