//
//  IntegerTypeUtilities.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 13/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

class IntegerTypeUtilities: QuickSpec {
    override func spec() {
        describe("UInt32") {
            it("should load from empty byte array") {
                let bytes: [UInt8] = [];
                expect(UInt32(littleEndianBytes: bytes)).to(equal(0))
            }
            
            it("should load from 4-byte array") {
                let bytes: [UInt8] = [1, 2, 3, 4];
                expect(UInt32(littleEndianBytes: bytes)).to(equal(0x04030201))
            }

            it("should load from small byte array") {
                let bytes: [UInt8] = [1, 2, 3];
                expect(UInt32(littleEndianBytes: bytes)).to(equal(0x030201))
            }
            
            it("should load from small byte array") {
                let bytes: [UInt8] = [1, 2, 3, 4, 5];
                expect(UInt32(littleEndianBytes: bytes)).to(equal(0x04030201))
            }
            
            it("should return little endian byte array") {
                let value: UInt32 = 0x01020304;
                expect(value.toLittleEndianBytes()).to(equal([0x04, 0x03, 0x02, 0x01]))
            }
        }
        
        describe("UInt16") {
            it("should load from empty byte array") {
                let bytes: [UInt8] = [];
                expect(UInt16(littleEndianBytes: bytes)).to(equal(0))
            }
            
            it("should load from 4-byte array") {
                let bytes: [UInt8] = [1, 2];
                expect(UInt16(littleEndianBytes: bytes)).to(equal(0x0201))
            }
            
            it("should load from small byte array") {
                let bytes: [UInt8] = [1];
                expect(UInt16(littleEndianBytes: bytes)).to(equal(0x01))
            }
            
            it("should load from small byte array") {
                let bytes: [UInt8] = [1, 2, 3];
                expect(UInt16(littleEndianBytes: bytes)).to(equal(0x0201))
            }
            
            it("should return little endian byte array") {
                let value: UInt16 = 0x0102;
                expect(value.toLittleEndianBytes()).to(equal([0x02, 0x01]))
            }
        }
    }
}