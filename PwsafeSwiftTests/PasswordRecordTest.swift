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

class PasswordRecordTest: QuickSpec {
    override func spec() {
        describe("PasswordRecord") {
            var record: PasswordRecord!
            
            beforeEach {
                record = PasswordRecord(uuid: UUID())
            }
            
            it("setValue should set value") {
                record.setValue("title", forKey: Password.title)
                expect(record.value(forKey: Password.title)).to(equal("title"))
            }
            
            it("setValue should update value") {
                record.setValue("title", forKey: Password.title)
                record.setValue("updated title", forKey: Password.title)
                expect(record.value(forKey: Password.title)).to(equal("updated title"))
            }
            
            it("setValue with should remove value") {
                record.setValue("title", forKey: Password.title)
                record.setValue(nil, forKey: Password.title)
                expect(record.value(forKey: Password.title)).to(beNil())
            }
        }
        
        describe("test field keys") {
            it("should get and set Title") {
                var record: PasswordRecord = PasswordRecord(uuid: UUID())
                
                record.setValue("title", forKey: Password.title)
                expect(record.title).to(equal("title"))
                
                record.title = "updated title"
                expect(record.value(forKey: Password.title)).to(equal("updated title"))
            }
            
            it("should get and set Username") {
                var record: PasswordRecord = PasswordRecord(uuid: UUID())
                
                record.setValue("username", forKey: Password.username)
                expect(record.username).to(equal("username"))
                
                record.username = "updated username"
                expect(record.value(forKey: Password.username)).to(equal("updated username"))
            }
            
            it("should get and set Notes") {
                var record: PasswordRecord = PasswordRecord(uuid: UUID())
                
                record.setValue("notes", forKey: Password.notes)
                expect(record.notes).to(equal("notes"))
                
                record.notes = "updated notes"
                expect(record.value(forKey: Password.notes)).to(equal("updated notes"))
            }
            
            it("should get and set Notes") {
                var record: PasswordRecord = PasswordRecord(uuid: UUID())
                
                record.setValue("url", forKey: Password.url)
                expect(record.url).to(equal("url"))
                
                record.url = "updated url"
                expect(record.value(forKey: Password.url)).to(equal("updated url"))
            }
            
            it("should get and set Email") {
                var record: PasswordRecord = PasswordRecord()
                
                record.setValue("email@none.none", forKey: Password.email)
                expect(record.email).to(equal("email@none.none"))
                
                record.email = "updated_email@none.none"
                expect(record.value(forKey: Password.email)).to(equal("updated_email@none.none"))
            }
        }
        
        describe("PasswordRecord: RawFieldsArrayConvertible") {
            it("should add UUID to rawFields") {
                let uuid = UUID()
                let uuidRawField = RawField(
                    typeCode: PwsafePasswordFieldType.uuid.rawValue,
                    bytes: Password.uuid.serializer.toByteArray(uuid))
                let record = PasswordRecord(rawFields: [uuidRawField])
                //todo: expect uuid in rawFields
            }
        }
    }
}
