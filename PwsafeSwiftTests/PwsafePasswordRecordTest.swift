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
                record = PwsafePasswordRecord(uuid: UUID())
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
        
        describe("test field keys") {
            it("should get and set Title") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("title", forKey: PwsafePasswordRecord.Title)
                expect(record.title).to(equal("title"))
                
                record.title = "updated title"
                expect(record.valueForKey(PwsafePasswordRecord.Title)).to(equal("updated title"))
            }
            
            it("should get and set Username") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("username", forKey: PwsafePasswordRecord.Username)
                expect(record.username).to(equal("username"))
                
                record.username = "updated username"
                expect(record.valueForKey(PwsafePasswordRecord.Username)).to(equal("updated username"))
            }
            
            it("should get and set Notes") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("notes", forKey: PwsafePasswordRecord.Notes)
                expect(record.notes).to(equal("notes"))
                
                record.notes = "updated notes"
                expect(record.valueForKey(PwsafePasswordRecord.Notes)).to(equal("updated notes"))
            }
            
            it("should get and set Notes") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("url", forKey: PwsafePasswordRecord.URL)
                expect(record.url).to(equal("url"))
                
                record.url = "updated url"
                expect(record.valueForKey(PwsafePasswordRecord.URL)).to(equal("updated url"))
            }
            
            it("should get and set Email") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord()
                
                record.setValue("email@none.none", forKey: PwsafePasswordRecord.Email)
                expect(record.email).to(equal("email@none.none"))
                
                record.email = "updated_email@none.none"
                expect(record.valueForKey(PwsafePasswordRecord.Email)).to(equal("updated_email@none.none"))
            }
        }
        
        describe("PwsafePasswordRecord: RawFieldsArrayConvertible") {
            it("should add UUID to rawFields") {
                let uuid = UUID()
                let uuidRawField = RawField(
                    typeCode: PwsafePasswordFieldType.uuid.rawValue,
                    bytes: PwsafePasswordRecord.UUID.serializer.toByteArray(uuid))
                let record = PwsafePasswordRecord(rawFields: [uuidRawField])
                //todo: expect uuid in rawFields
            }
        }
    }
}
