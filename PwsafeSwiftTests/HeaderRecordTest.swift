//
//  PwsafeHeaderRecord.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 08/12/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

import Quick
import Nimble
import PwsafeSwift

class HeaderRecordTest: QuickSpec {
    override func spec() {
        describe("HeaderRecord") {
            var record: HeaderRecord!
            
            beforeEach {
                record = HeaderRecord(uuid: UUID())
            }
            
            //todo: clean up
//            it("should be initialized with default uuid") {
//                expect(record.uuid).notTo(beNil())
//            }
        }
    }
}
