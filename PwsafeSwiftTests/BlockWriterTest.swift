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
                var writer = BlockWriter()
                writer.write([1, 2, 3, 4])
                expect(writer.data).to(equal([1, 2, 3, 4]))
                
                writer.finishBlock();
                expect(writer.data.count).to(equal(16))
            }
            
            it("should write UInt32") {
                var writer = BlockWriter()
                writer.write(UInt32(0x04030201))
                expect(writer.data).to(equal([1, 2, 3, 4]))
            }
            
            it("should write byte array size of one block") {
                var writer = BlockWriter()
                writer.write([UInt8](count:16, repeatedValue: 0))
                writer.finishBlock();
                expect(writer.data.count).to(equal(16))
            }
            
            it("should write byte array in one block, UInt32 in next block") {
                var writer = BlockWriter()
                writer.write([1, 2, 3, 4])
                writer.finishBlock();
                writer.write(UInt32(0x05060708))
                writer.finishBlock()
                
                expect(writer.data.count).to(equal(32))
//                expect(writer.data.prefix(4))
                
                
//                expect(writer.data).to(equal([1, 2, 3, 4]))
//                
//                expect(writer.data.count).to(equal(16))
//                
//                let result = [UInt8](writer.data.suffix(4))
//                expect(result).to(equal([8, 7, 6, 5]))
           }
            
        }
/*
        describe("BlockReader") {
            it("should read data to array") {
                let data:[UInt8] = [1, 2, 3, 4, 5, 6, 7]
                var reader = BlockReader(data: data)
                
                expect(reader.readBytes(3)).to(equal([1, 2, 3]))
                expect(reader.readBytes(4)).to(equal([4, 5, 6, 7]))
                expect(reader.readBytes(1)).to(beNil())
            }
            
            it("should read UInt32 little-endian") {
                let data:[UInt8] = [0x04, 0x03, 0x02, 0x01, 0xFF]
                var reader = BlockReader(data: data)
                
                let result: UInt32? = reader.readUInt32LE()
                
                expect(result).to(equal(0x01020304))
                expect(reader.readUInt32LE()).to(beNil())
            }
            
            it("should read UInt16 little-endian") {
                let data:[UInt8] = [0x02, 0x01, 0xFF]
                var reader = BlockReader(data: data)
                
                let result: UInt16? = reader.readUInt16LE()
                
                expect(result).to(equal(0x0102))
                expect(reader.readUInt16LE()).to(beNil())
            }
            
            it("should read UInt8") {
                let data:[UInt8] = [1, 23]
                var reader = BlockReader(data: data)
                
                expect(reader.readUInt8()).to(equal(0x01))
                expect(reader.readUInt8()).to(equal(23))
                expect(reader.readUInt8()).to(beNil())
            }
            
            it("should read block") {
                let data:[UInt8] = [
                    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                ]
                var reader = BlockReader(data: data)
                
                expect(reader.readBytes(1)).to(equal([1]))
                expect(reader.nextBlock()).to(equal(true))
                expect(reader.readBytes(1)).to(equal([2]))
                expect(reader.nextBlock()).to(equal(false))
            }

*/
    }
}