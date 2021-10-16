//
//  DataExtensionTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 11/02/2017.
//  Copyright © 2017 Anton Selyanin. All rights reserved.
//

import Foundation

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

class DataExtensionTest: QuickSpec {
    override func spec() {
        describe("Data.suffixData") {
            it("returns suffix data, up to the end") {
                let data = Data([0, 1, 2, 3, 4])
                
                expect(data.suffixData(2)) == Data([3, 4])
            }

            it("returns suffix data, through the end") {
                let data = Data([0, 1, 2, 3, 4])
                
                expect(data.suffixData(data.count + 1)) == data
            }
            
            it("works for empty data") {
                let data = Data()
                
                expect(data.suffixData(data.count + 1)) == data
            }

            it("returns empty") {
                let data = Data()
                
                expect(data.suffixData(0).count) == 0
            }
        }
        
        describe("prefixData") {
            it("returns prefix data") {
                let data = Data([0, 1, 2, 3, 4])
                
                expect(data.prefixData(2)) == Data([0, 1])
            }
            
            it("returns suffix data") {
                let data = Data([0, 1, 2, 3, 4])
                
                expect(data.prefixData(data.count + 1)) == data
            }
            
            it("works for empty data") {
                let data = Data()
                
                expect(data.prefixData(data.count + 1)) == data
            }
            
            it("returns empty") {
                let data = Data()
                
                expect(data.prefixData(0).count) == 0
            }
        }
    }
}
