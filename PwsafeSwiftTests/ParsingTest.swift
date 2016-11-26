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
        describe("reads bytes from data") {
            // Given
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("reads 3 bytes") {
                // When
                let result = Parsers.read(3).parse(data)!
                
                // Then
                expect(result.remainder) == Data(bytes:[3, 4, 5, 6])
                expect(result.parsed) == Data(bytes:[0, 1, 2])
            }
            
            it("reads 0 bytes") {
                // When
                let result = Parsers.read(0).parse(data)!
                
                // Then
                expect(result.remainder) == data
                expect(result.parsed) == Data(bytes:[])
            }

            it("returns nil if not enough bytes") {
                // When
                let result = Parsers.read(data.count + 1).parse(data)
                
                // Then
                expect(result).to(beNil())
            }
        }

        describe("expect bytes") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("returns bytes when equal to requested") {
                // When
                let result = Parsers.expect([0, 1, 2]).parse(data)!
                
                // Then
                expect(result.remainder) == Data(bytes:[3, 4, 5, 6])
                expect(result.parsed) == Data(bytes:[0, 1, 2])
            }
            
            it("returns nil sequence don't match") {
                // When
                let result = Parsers.expect([2, 1, 0]).parse(data)
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("expect string") {
            let data: Data = Data(bytes: "PWS".utf8Bytes() + [3, 4, 5, 6])
            
            it("returns bytes when equal to requested") {
                // When
                let result = Parsers.expect("PWS").parse(data)!
                
                // Then
                expect(result.remainder) == Data(bytes:[3, 4, 5, 6])
                expect(result.parsed) == "PWS"
            }
            
            it("returns nil sequence don't match") {
                // When
                let result = Parsers.expect("ABC").parse(data)
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("read all") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("reads all") {
                // When
                let result = Parsers.readAll().parse(data)
                
                // Then
                expect(result!.remainder) == Data(bytes:[])
                expect(result!.parsed) == data
            }
            
            it("reads and leave last N bytes") {
                // When
                let result = Parsers.readAll(leave: 2).parse(data)
                
                // Then
                expect(result!.remainder) == Data(bytes:[5, 6])
                expect(result!.parsed) == Data(bytes: [0, 1, 2, 3, 4])
            }
            
            it("return nil if suffix is too small") {
                // When
                let result = Parsers.readAll(leave: data.count + 1).parse(data)
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("read ByteArrayConvertible") {
            let data: Data = Data(bytes: [0x04, 0x03, 0x02, 0x01, 0xFF])

            it("reads UInt32") {
                // When
                let result: ParserResult<UInt32> = Parsers.read().parse(data)
                
                // Then
                expect(result!.remainder) == Data(bytes: [0xFF])
                expect(result!.parsed) == 0x01020304
            }
            
            it("returns nil if not enough bytes") {
                // When
                let result: ParserResult<UInt32> = Parsers
                    .read().parse(Data(bytes: [0x01]))
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("Parser<Data>.bytes") {
            it("converts to bytes") {
                // Given
                let parser = Parser<Data>.pure(Data(bytes: [0x01, 0x02, 0x03]))
                
                // When
                let result = parser.bytes.parse(Data())
                
                // Then
                expect(result!.parsed) == [0x01, 0x02, 0x03]
            }
        }
        
        describe("Parser<Data>.cut(requiredSuffix:)") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("cuts required suffix") {
                // When
                let result = Parser<Data>
                    .pure(data)
                    .cut(requiredSuffix: [5, 6])
                    .parse(Data())
                
                // Then
                expect(result!.remainder) == Data()
                expect(result!.parsed) == Data(bytes: [0, 1, 2, 3, 4])
            }
            
            it("returns nil when no suffix") {
                // When
                let result = Parser<Data>
                    .pure(data)
                    .cut(requiredSuffix: [0xff, 0xff])
                    .parse(Data())
                
                // Then
                expect(result).to(beNil())
            }
        }
    }
}
