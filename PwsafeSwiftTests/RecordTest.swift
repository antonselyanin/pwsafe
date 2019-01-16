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

class RecordTest: QuickSpec {
    override func spec() {
        describe("Record") {
            var record: Record!
            
            beforeEach {
                record = Record(uuid: UUID())
            }
            
            it("setValue should set value") {
                record.setValue("title", forKey: RecordKey.title)
                expect(record.value(forKey: RecordKey.title)) == "title"
            }
            
            it("updates value") {
                record.setValue("title", forKey: RecordKey.title)
                record.setValue("updated title", forKey: RecordKey.title)
                expect(record.value(forKey: RecordKey.title)) == "updated title"
            }
            
            it("setValue with should remove value") {
                record.setValue("title", forKey: RecordKey.title)
                record.setValue(nil, forKey: RecordKey.title)
                expect(record.value(forKey: RecordKey.title)).to(beNil())
            }

            it("removes value") {
                // Given
                record.setValue("title", forKey: RecordKey.email)

                // When
                record.remove(forKey: RecordKey.email)

                // Then
                expect(record.value(forKey: RecordKey.email)).to(beNil())
            }
        }
        
        describe("test field keys") {
            it("should get and set Title") {
                var record: Record = Record(uuid: UUID())
                
                record.setValue("title", forKey: RecordKey.title)
                expect(record.title) == "title"
                
                record.title = "updated title"
                expect(record.value(forKey: RecordKey.title)) == "updated title"
            }
            
            it("should get and set Username") {
                var record: Record = Record(uuid: UUID())
                
                record.setValue("username", forKey: RecordKey.username)
                expect(record.username) == "username"
                
                record.username = "updated username"
                expect(record.value(forKey: RecordKey.username)) == "updated username"
            }
            
            it("should get and set Notes") {
                var record: Record = Record(uuid: UUID())
                
                record.setValue("notes", forKey: RecordKey.notes)
                expect(record.notes) == "notes"
                
                record.notes = "updated notes"
                expect(record.value(forKey: RecordKey.notes)) == "updated notes"
            }
            
            it("should get and set Notes") {
                var record: Record = Record(uuid: UUID())
                
                record.setValue("url", forKey: RecordKey.url)
                expect(record.url) == "url"
                
                record.url = "updated url"
                expect(record.value(forKey: RecordKey.url)) == "updated url"
            }
            
            it("should get and set Email") {
                var record: Record = Record()
                
                record.setValue("email@none.none", forKey: RecordKey.email)
                expect(record.email) == "email@none.none"
                
                record.email = "updated_email@none.none"
                expect(record.value(forKey: RecordKey.email)) == "updated_email@none.none"
            }
        }
        
        describe("Record: RawFieldsArrayConvertible") {
            it("adds UUID to rawFields") {
                // Given
                let uuid = UUID()
                let uuidBytes = RecordKey.uuid.serializer.toByteArray(uuid)
                let uuidRawField = RawField(typeCode: RecordKey.uuid.code, bytes: uuidBytes)
                let record = Record(rawFields: [uuidRawField])
                
                // When
                let uuidField = record.rawFields.filter({ $0.typeCode == RecordKey.uuid.code }).first!
                
                // Then
                expect(uuidField.bytes) == uuidBytes
            }
        }
    }
}
