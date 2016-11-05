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
                let expectedValue = UUID(uuidString: "12121212-1212-1212-1212-121212121212")!
                let expectedBytes = [UInt8](repeating: 0x12, count: 16)
                
                let value = serializer.fromByteArray(expectedBytes)!
                expect(value) == expectedValue
                
                let bytes: [UInt8] = serializer.toByteArray(expectedValue)
                expect(bytes) == expectedBytes
            }
            
            it("should fill with zeros if not enough bytes") {
                let serializer = ValueSerializers.uuids
                let expectedValue = UUID(uuidString: "12121212-0000-0000-0000-000000000000")!
                let inputBytes = [UInt8](repeating: 0x12, count: 4)
                let expectedBytes = inputBytes + [UInt8](repeating: 0, count: 12)
                
                let value = serializer.fromByteArray(inputBytes)!
                expect(value) == expectedValue
                
                let bytes: [UInt8] = serializer.toByteArray(expectedValue)
                expect(bytes) == expectedBytes

            }
        }
        
        describe("StringSerializer") {
            it("should create from utf8 bytes") {
                let serializer = ValueSerializers.strings
                let testString = "test string 😎"
                let bytes = testString.utf8Bytes()
                let extracted = serializer.fromByteArray(bytes)
                expect(extracted) == testString
            }
        }
    }
}
