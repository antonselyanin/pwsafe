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
                record.setValue("title", forKey: PwsafePasswordRecord.title)
                expect(record.valueForKey(PwsafePasswordRecord.title)).to(equal("title"))
            }
            
            it("setValue should update value") {
                record.setValue("title", forKey: PwsafePasswordRecord.title)
                record.setValue("updated title", forKey: PwsafePasswordRecord.title)
                expect(record.valueForKey(PwsafePasswordRecord.title)).to(equal("updated title"))
            }
            
            it("setValue with should remove value") {
                record.setValue("title", forKey: PwsafePasswordRecord.title)
                record.setValue(nil, forKey: PwsafePasswordRecord.title)
                expect(record.valueForKey(PwsafePasswordRecord.title)).to(beNil())
            }
        }
        
        describe("test field keys") {
            it("should get and set Title") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("title", forKey: PwsafePasswordRecord.title)
                expect(record.title).to(equal("title"))
                
                record.title = "updated title"
                expect(record.valueForKey(PwsafePasswordRecord.title)).to(equal("updated title"))
            }
            
            it("should get and set Username") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("username", forKey: PwsafePasswordRecord.username)
                expect(record.username).to(equal("username"))
                
                record.username = "updated username"
                expect(record.valueForKey(PwsafePasswordRecord.username)).to(equal("updated username"))
            }
            
            it("should get and set Notes") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("notes", forKey: PwsafePasswordRecord.notes)
                expect(record.notes).to(equal("notes"))
                
                record.notes = "updated notes"
                expect(record.valueForKey(PwsafePasswordRecord.notes)).to(equal("updated notes"))
            }
            
            it("should get and set Notes") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord(uuid: UUID())
                
                record.setValue("url", forKey: PwsafePasswordRecord.url)
                expect(record.url).to(equal("url"))
                
                record.url = "updated url"
                expect(record.valueForKey(PwsafePasswordRecord.url)).to(equal("updated url"))
            }
            
            it("should get and set Email") {
                var record: PwsafePasswordRecord = PwsafePasswordRecord()
                
                record.setValue("email@none.none", forKey: PwsafePasswordRecord.email)
                expect(record.email).to(equal("email@none.none"))
                
                record.email = "updated_email@none.none"
                expect(record.valueForKey(PwsafePasswordRecord.email)).to(equal("updated_email@none.none"))
            }
        }
        
        describe("PwsafePasswordRecord: RawFieldsArrayConvertible") {
            it("should add UUID to rawFields") {
                let uuid = UUID()
                let uuidRawField = RawField(
                    typeCode: PwsafePasswordFieldType.uuid.rawValue,
                    bytes: PwsafePasswordRecord.uuid.serializer.toByteArray(uuid))
                let record = PwsafePasswordRecord(rawFields: [uuidRawField])
                //todo: expect uuid in rawFields
            }
        }
    }
}
