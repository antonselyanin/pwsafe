//
//  FieldsContainer.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 05/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

internal struct FieldsContainer<RecordType> {
    internal var fields: [RawField]
    
    internal func valueForKey<ValueType>(_ key: FieldKey<RecordType, ValueType>) -> ValueType? {
        return fields.lazy
            .filter({ $0.typeCode == key.code })
            .flatMap({ key.serializer.fromByteArray($0.bytes) })
            .first
    }
    
    internal mutating func setValue<ValueType>(_ value: ValueType?, forKey key: FieldKey<RecordType, ValueType>) {
        let index = fields.index(where: { $0.typeCode == key.code })
        
        if let value = value {
            let newValue = RawField(typeCode: key.code, bytes: key.serializer.toByteArray(value))
            
            if let index = index {
                fields[index] = newValue
            } else {
                fields.append(newValue)
            }
        } else if let index = index {
            fields.remove(at: index)
        }
    }
}
