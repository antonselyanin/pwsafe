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
        describe("parseRawPwsafeRecords") {
            it ("parses multiple records") {
                // Given
                let writer = BlockWriter()
                writer.writeRawField(type: 1, data: [1, 2, 3, 4])
                writer.writeRawField(type: 2, data: [5, 6, 7])
                writer.writeRawField(type: 0xff)
                
                writer.writeRawField(type: 1, data: [1, 2, 3, 4])
                writer.writeRawField(type: 5)
                writer.writeRawField(type: 5)
                writer.writeRawField(type: 0xff)
                
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
