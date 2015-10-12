//
//  ArrayExtensionTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 04/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import PwsafeSwift

class ArrayExtensionTest: QuickSpec {
    override func spec() {
        describe("toChunks") {
            it("should produce chunks") {
                let chunks = Array(0..<10).toChunks(3)
                expect(chunks).to(equal([
                    [0, 1, 2], [3, 4, 5], [6, 7, 8], [9]
                    ]))
            }
        }
        
        describe("rangeSequence") {
            it ("should generate ranges") {
                let seq = rangeSequence(0..<9, stride: 3)
                expect(Array(seq)).to(equal([0..<3, 3..<6, 6..<9]))
            }

            it ("should generate ranges") {
                let seq = rangeSequence(0..<7, stride: 3)
                expect(Array(seq)).to(equal([0..<3, 3..<6, 6..<7]))
            }
            
            it ("should generate ranges") {
                let seq = rangeSequence(0..<7, stride: 10)
                expect(Array(seq)).to(equal([0..<7]))
            }
            
            it ("should not generate ranges") {
                let seq = rangeSequence(0..<0, stride: 3)
                expect(Array(seq)).to(equal([]))
            }
        }
    }
}