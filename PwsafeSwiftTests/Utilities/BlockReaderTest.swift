//
// Created by Anton Selyanin on 12/09/15.
// Copyright (c) 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

class BlockReaderTest: QuickSpec {
    override func spec() {
        describe("BlockReader") {
            it("should read data to array") {
                let data:[UInt8] = [1, 2, 3, 4, 5, 6, 7]
                var reader = BlockReader(data: data)
                
                expect(reader.readBytes(3)) == [1, 2, 3]
                expect(reader.readBytes(4)) == [4, 5, 6, 7]
                expect(reader.readBytes(1)).to(beNil())
            }
            
            it("should read UInt32 little-endian") {
                let data:[UInt8] = [0x04, 0x03, 0x02, 0x01, 0xFF]
                var reader = BlockReader(data: data)
                
                let result: UInt32? = reader.read()
                
                expect(result) == 0x01020304
                expect(reader.read() as UInt32?).to(beNil())
            }
            
            it("should read UInt16 little-endian") {
                let data:[UInt8] = [0x02, 0x01, 0xFF]
                var reader = BlockReader(data: data)
                
                let result: UInt16? = reader.read()
                
                expect(result) == 0x0102
                expect(reader.read() as UInt16?).to(beNil())
            }
            
            it("should read UInt8") {
                let data:[UInt8] = [1, 23]
                var reader = BlockReader(data: data)
                
                expect(reader.read() as UInt8?) == 0x01
                expect(reader.read() as UInt8?) == 23
                expect(reader.read() as UInt8?).to(beNil())
            }
            
            it("should read block") {
                let data:[UInt8] = [
                    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                ]
                var reader = BlockReader(data: data)
                
                expect(reader.readBytes(1)) == [1]
                expect(reader.nextBlock()) == true
                expect(reader.readBytes(1)) == [2]
                expect(reader.nextBlock()) == false
            }

            it("should not skip next block if we read a whole block") {
                // Given
                let data:[UInt8] = [
                    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    ]
                var reader = BlockReader(data: data, blockSize: 16)
                
                // When
                let _ = reader.readBytes(16)
                expect(reader.nextBlock()) == true
                
                // Then
                expect(reader.readBytes(1)) == [2]
                expect(reader.nextBlock()) == false
            }
        }
    }
}
