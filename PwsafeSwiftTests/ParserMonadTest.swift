//
//  ParserMonadTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 22/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import PwsafeSwift

class ParserMonadTest: QuickSpec {
    override func spec() {
        describe("map operator") {
            it("maps values") {
                // Given
                let parser = Parser<String>.pure("abc").map({ $0.uppercased() })
                
                // When
                let (_, result) = parser.parse(Data())!
                
                // Then
                expect(result) == "ABC"
            }
            
            it("returns nil when parser result is nil") {
                // Given
                let parser: Parser<String> = Parser<String>
                    .empty().map({ (str: String) -> String in str.uppercased() })
                
                // When
                let result = parser.parse(Data())
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("flatMap operator") {
            it("maps values") {
                // Given
                let parser: Parser<Int> = Parser<String>.pure("abc").flatMap {
                    (_: String) -> Parser<Int> in
                    return .pure(1)
                }
                
                // When
                let (_, result) = parser.parse(Data())!
                
                // Then
                expect(result) == 1
            }
            
            it("returns nil when parser result is nil") {
                // Given
                let parser: Parser<Int> = Parser<String>.empty().flatMap {
                    (_: String) -> Parser<Int> in
                    return .pure(1)
                }
                
                // When
                let result = parser.parse(Data())
                
                // Then
                expect(result).to(beNil())
            }
            
            it("returns nil when flatMap result is nil") {
                // Given
                let parser: Parser<Int> = Parser<String>.pure("abc").flatMap {
                    (_: String) -> Parser<Int> in
                    return .empty()
                }
                
                // When
                let result = parser.parse(Data())
                
                // Then
                expect(result).to(beNil())
            }
        }
        
        describe("<* discard right operator") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("discards right") {
                let parser = Parsers.read(2) <* Parsers.read(3)
                
                let result = parser.parse(data)
                
                expect(result!.parsed) == Data(bytes: [0, 1])
                expect(result!.remainder) == Data(bytes: [5, 6])
            }
        }

        describe("*> discard left operator") {
            let data: Data = Data(bytes: [0, 1, 2, 3, 4, 5, 6])
            
            it("discard left") {
                let parser = Parsers.read(2) *> Parsers.read(3)
                
                let result = parser.parse(data)
                
                expect(result!.parsed) == Data(bytes: [2, 3, 4])
                expect(result!.remainder) == Data(bytes: [5, 6])
            }
        }
    }
}
