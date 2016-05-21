//
//  FieldValueSerializersTest.swift
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
        describe("UUIDSerializer") {
            it("should extract UUID from bytes") {
                let serializer = ValueSerializers.uuids
                let expectedValue = NSUUID(UUIDString: "12121212-1212-1212-1212-121212121212")!
                let expectedBytes = [UInt8](count: 16, repeatedValue: 0x12)
                
                let value = serializer.fromByteArray(bytes: expectedBytes)!
                expect(value).to(equal(expectedValue))
                
                let bytes: [UInt8] = serializer.toByteArray(value: expectedValue)
                expect(bytes).to(equal(expectedBytes))
            }
            
            it("should fill with zeros if not enough bytes") {
                let serializer = ValueSerializers.uuids
                let expectedValue = NSUUID(UUIDString: "12121212-0000-0000-0000-000000000000")!
                let inputBytes = [UInt8](count: 4, repeatedValue: 0x12)
                let expectedBytes = inputBytes + [UInt8](count: 12, repeatedValue: 0)
                
                let value = serializer.fromByteArray(bytes: inputBytes)!
                expect(value).to(equal(expectedValue))
                
                let bytes: [UInt8] = serializer.toByteArray(value: expectedValue)
                expect(bytes).to(equal(expectedBytes))

            }
        }
        
        describe("StringSerializer") {
            it("should create from utf8 bytes") {
                let serializer = ValueSerializers.strings
                let testString = "test string 😎"
                let bytes = testString.utf8Bytes()
                let extracted = serializer.fromByteArray(bytes: bytes)
                expect(extracted).to(equal(testString))
            }
        }
    }
}