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
    
}

class FieldsContainerTest: QuickSpec {
    override func spec() {
        describe("FieldsContainer") {
            it("writes new raw field") {
                // Given
                var container = FieldsContainer<MockRecordType>(fields: [])
                let value = "value"
                
                // When
                container.setValue(value, forKey: MockRecordType.stringField)
                
                // Then
                expect(container.valueForKey(MockRecordType.stringField)) == value
                expect(container.fields) == [RawField(typeCode: 0x01, bytes: value.utf8Bytes())]
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
    }
}
