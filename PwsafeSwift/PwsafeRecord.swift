//
//  PwsafeRecord.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public protocol PwsafeRecord: Equatable {
    static var uuid: FieldKey<Self, UUID> { get }
    
    var uuid: UUID { get }
    
    func valueForKey<ValueType>(_ key: FieldKey<Self, ValueType>) -> ValueType?
    
    mutating func setValue<ValueType>(_ value: ValueType?, forKey: FieldKey<Self, ValueType>)
}

//TODO: find a better name
protocol PwsafeRecordExt: PwsafeRecord {
    var uuid: UUID { get }
    
    var fields: FieldsContainer<Self> { get set }
}

extension PwsafeRecordExt {
    public func valueForKey<ValueType>(_ key: FieldKey<Self, ValueType>) -> ValueType? {
        return fields.valueForKey(key)
    }

    public mutating func setValue<ValueType>(_ value: ValueType?, forKey key: FieldKey<Self, ValueType>) {
        fields.setValue(value, forKey: key)
    }
}
