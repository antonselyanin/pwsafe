//
//  PwsafeRecordTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 18/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Quick
import Nimble
@testable import PwsafeSwift

class PwsafePasswordRecordTest: QuickSpec {
    override func spec() {
        describe("PwsafePasswordRecord") {
            var record: PwsafePasswordRecord!
            
            beforeEach {
                record = PwsafePasswordRecord(uuid: NSUUID())
            }
            
            it("setValue should set value") {
                record.setValue("title", forKey: PwsafePasswordRecord.Title)
                expect(record.valueForKey(PwsafePasswordRecord.Title)).to(equal("title"))
            }
            
            it("setValue should update value") {
                record.setValue("title", forKey: PwsafePasswordRecord.Title)
                record.setValue("updated title", forKey: PwsafePasswordRecord.Title)
                expect(record.valueForKey(PwsafePasswordRecord.Title)).to(equal("updated title"))
            }
            
            it("setValue with should remove value") {
                record.setValue("title", forKey: PwsafePasswordRecord.Title)
                record.setValue(nil, forKey: PwsafePasswordRecord.Title)
                expect(record.valueForKey(PwsafePasswordRecord.Title)).to(beNil())
            }
        }
        
        describe("PwsafePasswordRecord: RawFieldsArrayConvertible") {
            it("should add UUID to rawFields") {
                let uuid = NSUUID()
                let uuidRawField = RawField(
                    typeCode: PwsafePasswordFieldType.UUID.rawValue,
                    bytes: PwsafePasswordRecord.UUID.toByteArray(value: uuid))
                let record = PwsafePasswordRecord(rawFields: [uuidRawField])
                //todo: expect uuid in rawFields
            }
        }
    }
}