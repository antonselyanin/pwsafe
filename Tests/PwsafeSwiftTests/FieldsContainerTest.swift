//
//  FieldContainerTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 10/12/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

enum MockRecordType: RecordType {
    static var uuid: FieldKey<MockRecordType, UUID> { fatalError() }
    
    static let stringField: FieldKey<MockRecordType, String> = key(0x01, ValueSerializers.strings)

    static let stringListField: ListFieldKey<MockRecordType, String> = listKey(0x02, ValueSerializers.strings)
}

class FieldsContainerTest: QuickSpec {
    override func spec() {
        describe("FieldsContainer singleton fields") {
            it("writes new raw field") {
                // Given
                var container = FieldsContainer<MockRecordType>(fields: [])
                let value = "value"
                
                // When
                container.setValue(value, forKey: MockRecordType.stringField)
                
                // Then
                expect(container.valueForKey(MockRecordType.stringField)) == value
                let fields = container.fields
//                expect(fields) == [RawField(typeCode: 0x01, bytes: value.utf8Bytes())]
//                expect(container.fields) == [RawField(typeCode: 0x01, bytes: value.utf8Bytes())]
            }
            
            it("updates raw field") {
                // Given
                var container = FieldsContainer<MockRecordType>(fields: [])
                container.setValue("old value", forKey: MockRecordType.stringField)
                let value = "value"
                
                // When
                container.setValue(value, forKey: MockRecordType.stringField)
                
                // Then
                expect(container.valueForKey(MockRecordType.stringField)) == value
                expect(container.fields) == [RawField(typeCode: 0x01, bytes: value.utf8Bytes())]
            }
            
            it("removes raw field") {
                // Given
                var container = FieldsContainer<MockRecordType>(fields: [])
                let value = "value"
                container.setValue(value, forKey: MockRecordType.stringField)
                
                // When
                container.setValue(nil, forKey: MockRecordType.stringField)
                
                // Then
                expect(container.valueForKey(MockRecordType.stringField)).to(beNil())
                expect(container.fields) == []
            }
        }
        
        describe("FieldsContainer singleton fields") {
            it("reads array of fields") {
                // Given
                let value1 = "value1"
                let value2 = "value2"
                
                let container = FieldsContainer<MockRecordType>(fields: [
                    RawField(typeCode: 0x02, bytes: value1.utf8Bytes()),
                    RawField(typeCode: 0x02, bytes: value2.utf8Bytes())
                    ])
                
                // When
                let values = container.values(forKey: MockRecordType.stringListField)
                
                // Then
                expect(values) == ["value1", "value2"]
            }
            
            it("adds value, no other fields with the same type") {
                // Given
                let value = "value"
                var container = FieldsContainer<MockRecordType>(fields: [])
                
                // When
                container.add(value: value, forKey: MockRecordType.stringListField)
                
                // Then
                expect(container.fields) == [RawField(typeCode: 0x02, bytes: value.utf8Bytes())]
            }

            it("doesn't add value if it already exists") {
                // Given
                let value = "value"
                var container = FieldsContainer<MockRecordType>(fields: [
                    RawField(typeCode: 0x02, bytes: value.utf8Bytes())
                    ])
                
                // When
                container.add(value: value, forKey: MockRecordType.stringListField)
                
                // Then
                expect(container.fields) == [RawField(typeCode: 0x02, bytes: value.utf8Bytes())]
            }

            it("removes value") {
                // Given
                let value = "value"
                var container = FieldsContainer<MockRecordType>(fields: [
                    RawField(typeCode: 0x01, bytes: "unknown value".utf8Bytes()),
                    RawField(typeCode: 0x02, bytes: "some value".utf8Bytes()),
                    RawField(typeCode: 0x02, bytes: value.utf8Bytes())
                    ])
                
                // When
                container.remove(value: value, forKey: MockRecordType.stringListField)
                
                // Then
                expect(container.fields) == [
                    RawField(typeCode: 0x01, bytes: "unknown value".utf8Bytes()),
                    RawField(typeCode: 0x02, bytes: "some value".utf8Bytes())
                ]
            }
            
            it("removes all values by type") {
                // Given
                let value = "value"
                var container = FieldsContainer<MockRecordType>(fields: [
                    RawField(typeCode: 0x01, bytes: "unknown value".utf8Bytes()),
                    RawField(typeCode: 0x02, bytes: "some value".utf8Bytes()),
                    RawField(typeCode: 0x02, bytes: value.utf8Bytes())
                    ])
                
                // When
                container.removeAll(forKey: MockRecordType.stringListField)
                
                // Then
                expect(container.fields) == [
                    RawField(typeCode: 0x01, bytes: "unknown value".utf8Bytes())
                ]
            }
        }
    }
}
