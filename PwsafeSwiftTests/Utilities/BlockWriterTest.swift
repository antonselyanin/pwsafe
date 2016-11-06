//
//  BlockWriterTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

class BlockWriterTest: QuickSpec {
    override func spec() {
        describe("BlockWriter") {
            it("should write byte array with block") {
                let writer = BlockWriter()
                writer.write([1, 2, 3, 4])
                expect(writer.data) == [1, 2, 3, 4]
                
                writer.finishBlock();
                expect(writer.data.count) == 16
            }
            
            it("should write UInt32") {
                let writer = BlockWriter()
                writer.write(UInt32(0x04030201))
                expect(writer.data) == [1, 2, 3, 4]
            }
            
            it("should write byte array size of one block") {
                let writer = BlockWriter()
                writer.write([UInt8](repeating: 0, count: 16))
                writer.finishBlock()
                expect(writer.data.count) == 16
            }
            
            it("should write byte array in one block, UInt32 in next block") {
                let writer = BlockWriter()
                writer.write([1, 2, 3, 4])
                writer.finishBlock()
                writer.write(UInt32(0x05060708))
                writer.finishBlock()
                
                expect(writer.data.count) == 32
                expect(Array(writer.data.prefix(4))) == [1, 2, 3, 4]
                expect(Array(writer.data[16..<20])) == [8, 7, 6, 5]
            }
            
            it ("should write raw field") {
                let writer = BlockWriter()
                
                writer.writeRawField(type: 0x01, data: [0x05, 0x06, 0x07, 0x08])
                
                expect(writer.data.count) == 16
                expect(Array(writer.data[0..<4])) == [0x04, 0x00, 0x00, 0x00]
                expect(writer.data[4]) == 0x01
                expect(Array(writer.data[5..<9])) == [0x05, 0x06, 0x07, 0x08]
            }
            
            it ("should write empty raw field") {
                let writer = BlockWriter()
                
                writer.writeRawField(type: 0xff)
                
                expect(writer.data.count) == 16
                expect(Array(writer.data[0..<4])) == [0x00, 0x00, 0x00, 0x00]
                expect(writer.data[4]) == 0xff
            }
        }
    }
}
