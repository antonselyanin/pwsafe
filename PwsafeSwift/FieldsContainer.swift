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
    
    internal func valueForKey<Value>(_ key: FieldKey<RecordType, Value>) -> Value? {
        return values(by: key.code, serializer: key.serializer.fromByteArray)
            .first
    }
    
    internal mutating func setValue<Value>(_ value: Value?, forKey key: FieldKey<RecordType, Value>) {
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
    
    internal func values<Value>(forKey key: ListFieldKey<RecordType, Value>) -> [Value] {
        return values(by: key.code, serializer: key.serializer.fromByteArray)
    }
    
    internal mutating func add<Value>(value: Value, forKey key: ListFieldKey<RecordType, Value>) {
        let field = RawField(typeCode: key.code, bytes: key.serializer.toByteArray(value))
        
        guard !fields.contains(field) else { return }
        
        fields.append(RawField(typeCode: key.code, bytes: key.serializer.toByteArray(value)))
    }
    
    internal mutating func remove<Value>(value: Value, forKey key: ListFieldKey<RecordType, Value>) {
        let field = RawField(typeCode: key.code, bytes: key.serializer.toByteArray(value))
        
        fields = fields.filter({ $0 != field })
    }
    
    internal mutating func removeAll<Value>(forKey key: ListFieldKey<RecordType, Value>) {
        fields = fields.filter({ $0.typeCode != key.code })
    }
    
    private func values<Value>(by typeCode: UInt8, serializer: ([UInt8]) -> Value?) -> [Value] {
        return fields.lazy
            .filter({ $0.typeCode == typeCode })
            .flatMap({ serializer($0.bytes) })
    }
}
