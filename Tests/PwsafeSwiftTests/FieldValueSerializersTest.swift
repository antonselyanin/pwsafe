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
        describe("UUID serializer") {
            it("should extract UUID from bytes") {
                let serializer = ValueSerializers.uuid
                let expectedValue = UUID(uuidString: "12121212-1212-1212-1212-121212121212")!
                let expectedBytes = [UInt8](repeating: 0x12, count: 16)
                
                let value = serializer.fromByteArray(expectedBytes)!
                expect(value) == expectedValue
                
                let bytes: [UInt8] = serializer.toByteArray(expectedValue)
                expect(bytes) == expectedBytes
            }
            
            it("should fill with zeros if not enough bytes") {
                let serializer = ValueSerializers.uuid
                let expectedValue = UUID(uuidString: "12121212-0000-0000-0000-000000000000")!
                let inputBytes = [UInt8](repeating: 0x12, count: 4)
                let expectedBytes = inputBytes + [UInt8](repeating: 0, count: 12)
                
                let value = serializer.fromByteArray(inputBytes)!
                expect(value) == expectedValue
                
                let bytes: [UInt8] = serializer.toByteArray(expectedValue)
                expect(bytes) == expectedBytes

            }
        }
        
        describe("String serializer") {
            it("should create from utf8 bytes") {
                let serializer = ValueSerializers.strings
                let testString = "test string 😎"
                let bytes = testString.utf8Bytes()
                let extracted = serializer.fromByteArray(bytes)
                expect(extracted) == testString
            }
        }
        
        describe("Date serializer") {
            let rfc3339DateFormatter = DateFormatter()
            rfc3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            rfc3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            rfc3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            it("should create from utf8 bytes") {
                let date = rfc3339DateFormatter.date(from: "1996-12-19T16:39:57-08:00")!
                
                let serializer = ValueSerializers.date
                
                let array = serializer.toByteArray(date)
                let deserializedDate = serializer.fromByteArray(array)
                
                expect(deserializedDate) == date
            }
        }
        
        describe("Group serializer") {
            it("deserializes") {
                let bytes = "level1.level2.level3".utf8Bytes()
                let group = ValueSerializers.group.fromByteArray(bytes)
                
                expect(group?.segments) == ["level1", "level2", "level3"]
            }
            it("serializes") {
                let group = Group(segments: ["level1", "level2", "level3"])
                let bytes = ValueSerializers.group.toByteArray(group)
                
                expect(bytes) == "level1.level2.level3".utf8Bytes()
            }
        }
    }
}
