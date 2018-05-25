//
//  PwsafeParsingInternalTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 18/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import PwsafeSwift

class PwsafeParsingInternalTest: QuickSpec {
    //todo: add test for failures!
    
    override func spec() {
        describe("RawField parser") {
            it("parses RawField") {
                // Given
                let writer = BlockWriter()
                writer.write(UInt32(5))
                writer.write(UInt8(1))

                // When
                let result = RawField.parser.parse(Data(bytes: writer.data))
                
                // Then
                expect(result.value).to(beNil())
            }
            
            it("fails if not enough data") {
                let fieldData: [UInt8] = [1, 2, 3, 4]
                
                let writer = BlockWriter()
                writer.write(UInt32(fieldData.count))
                writer.write(UInt8(1))
                writer.write(fieldData)
                
                var data = Data(bytes: writer.data)
                data.append(5)
                data.append(6)
                data.append(7)
                
                let parsed = RawField.parser.parse(data).value!
                
                expect(parsed.remainder) == Data(bytes: [5, 6, 7])
                expect(parsed.value) == RawField(typeCode: 1, bytes: [1, 2, 3, 4])
            }
        }
        
        describe("parseRawPwsafeRecords") {
            it ("parses multiple records") {
                // Given
                let writer = BlockWriter()
                try! writer.writeRawField(type: 1, data: [1, 2, 3, 4])
                try! writer.writeRawField(type: 2, data: [5, 6, 7])
                try! writer.writeRawField(type: 0xff)
                
                try! writer.writeRawField(type: 1, data: [1, 2, 3, 4])
                try! writer.writeRawField(type: 5)
                try! writer.writeRawField(type: 5)
                try! writer.writeRawField(type: 0xff)
                
                // When
                let rawRecords = try! parseRawPwsafeRecords(writer.data)
                
                // Then
                expect(rawRecords.count) == 2
                
                expect(rawRecords[0]) == [
                    RawField(typeCode: 1, bytes: [1, 2, 3, 4]),
                    RawField(typeCode: 2, bytes: [5, 6, 7])
                ]
                
                expect(rawRecords[1]) == [
                    RawField(typeCode: 1, bytes: [1, 2, 3, 4]),
                    RawField(typeCode: 5, bytes: []),
                    RawField(typeCode: 5, bytes: [])
                ]
            }
        }
    }
}
