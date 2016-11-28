//
//  ParsingTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 21/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import PwsafeSwift

class ParsingTest: QuickSpec {
    override func spec() {
        let twoBytesReader: Parser<[UInt8]> = Parser { input in
            guard input.count >= 2 else { return .failure(ParserError.error) }
            let parsed: [UInt8] = Array(input.prefix(2))
            let remainder: Data = Data(input.suffix(from: 2))
            return .success(Parsed(remainder: remainder, value: parsed))
        }
        
        describe("reads bytes from data") {
            // Given
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("reads 3 bytes") {
                // When
                let parsed = Parsers.read(3).parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes:[3, 4, 5, 6])
                expect(parsed.value) == Data(bytes:[0, 1, 2])
            }
            
            it("reads 0 bytes") {
                // When
                let parsed = Parsers.read(0).parse(data).value!
                
                // Then
                expect(parsed.remainder) == data
                expect(parsed.value) == Data()
            }

            it("returns nil if not enough bytes") {
                // When
                let result = Parsers.read(data.count + 1).parse(data)
                
                // Then
                expect(result.value).to(beNil())
            }
        }

        describe("expect bytes") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("returns bytes when equal to requested") {
                // When
                let parsed = Parsers.expect([0, 1, 2]).parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes:[3, 4, 5, 6])
                expect(parsed.value) == Data(bytes:[0, 1, 2])
            }
            
            it("returns nil sequence don't match") {
                // When
                let result = Parsers.expect([2, 1, 0]).parse(data)
                
                // Then
                expect(result.value).to(beNil())
            }
        }
        
        describe("expect string") {
            let data: Data = Data(bytes: "PWS".utf8Bytes() + [3, 4, 5, 6])
            
            it("returns bytes when equal to requested") {
                // When
                let parsed = Parsers.expect("PWS").parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes:[3, 4, 5, 6])
                expect(parsed.value) == "PWS"
            }
            
            it("returns nil sequence don't match") {
                // When
                let result = Parsers.expect("ABC").parse(data)
                
                // Then
                expect(result.value).to(beNil())
            }
        }
        
        describe("read all") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("reads all") {
                // When
                let parsed = Parsers.readAll().parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes:[])
                expect(parsed.value) == data
            }
            
            it("reads and leave last N bytes") {
                // When
                let parsed = Parsers.readAll(leave: 2).parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes:[5, 6])
                expect(parsed.value) == Data(bytes: [0, 1, 2, 3, 4])
            }
            
            it("returns error if suffix is too small") {
                // When
                let result = Parsers.readAll(leave: data.count + 1).parse(data).value
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("read ByteArrayConvertible") {
            let data: Data = Data(bytes: [0x04, 0x03, 0x02, 0x01, 0xFF])

            it("reads UInt32") {
                // When
                let parsed: Parsed<UInt32> = Parsers.read().parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes: [0xFF])
                expect(parsed.value) == 0x01020304
            }
            
            it("returns nil if not enough bytes") {
                // When
                let result: ParserResult<UInt32> = Parsers
                    .read().parse(Data(bytes: [0x01]))
                
                // Then
                expect(result.value).to(beNil())
            }
        }
        
        describe("Parser<Data>.bytes") {
            it("converts to bytes") {
                // Given
                let parser = Parser<Data>.pure(Data(bytes: [0x01, 0x02, 0x03]))
                
                // When
                let parsed = parser.bytes.parse(Data()).value!
                
                // Then
                expect(parsed.value) == [0x01, 0x02, 0x03]
            }
        }
        
        describe("Parser<Data>.cut(requiredSuffix:)") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("cuts required suffix") {
                // When
                let parsed = Parser<Data>
                    .pure(data)
                    .cut(requiredSuffix: [5, 6])
                    .parse(Data()).value!
                
                // Then
                expect(parsed.remainder) == Data()
                expect(parsed.value) == Data(bytes: [0, 1, 2, 3, 4])
            }
            
            it("returns nil when no suffix") {
                // When
                let result = Parser<Data>
                    .pure(data)
                    .cut(requiredSuffix: [0xff, 0xff])
                    .parse(Data())
                
                // Then
                expect(result.value).to(beNil())
            }
        }
        
        describe("ParserProtocol.many") {
            it("returns array") {
                // When
                let parser = twoBytesReader.many
                let parsed = parser.parse(Data(bytes: [0, 1, 2, 3, 4])).value!
                
                // Then
                expect(parsed.value.count) == 2
                expect(parsed.value[0]) == [0, 1]
                expect(parsed.value[1]) == [2, 3]
                
                expect(parsed.remainder) == Data(bytes: [4])
            }
            
            it("return empty if can't parse") {
                // When
                let parser = twoBytesReader.many
                let parsed = parser.parse(Data(bytes: [1])).value!
                
                // Then
                expect(parsed.value.count) == 0
                expect(parsed.remainder) == Data(bytes: [1])
            }
        }
        
        describe("ParserProtocol.aligned(blockSize:)") {
            let data = Data(bytes: [0, 1, 2, 3, 4])
            
            it("ensures that data is read in blocks of specified size") {
                // When
                let parser = twoBytesReader.aligned(blockSize: 3)
                let parsed = parser.parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes: [3, 4])
                expect(parsed.value) == [0, 1]
            }
            
            it("doesn't align if reading already aligned") {
                // When
                let parser = twoBytesReader.aligned(blockSize: 2)
                let parsed = parser.parse(data).value!
                
                // Then
                expect(parsed.remainder) == Data(bytes: [2, 3, 4])
                expect(parsed.value) == [0, 1]
            }
            
        }
    }
}
