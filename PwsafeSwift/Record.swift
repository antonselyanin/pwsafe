//
//  Record.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 03/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public typealias HeaderRecord = Record<Header>
public typealias PasswordRecord = Record<Password>

public protocol RecordType {
    static var uuid: FieldKey<Self, UUID> { get }
}


public protocol RecordProtocol {
    associatedtype `Type`: RecordType
    
    var uuid: UUID { get }
    
    func value<ValueType>(forKey key: FieldKey<Type, ValueType>) -> ValueType?
    
    mutating func setValue<ValueType>(_ value: ValueType?, forKey key: FieldKey<Type, ValueType>)
}

public struct Record<Type: RecordType>: RecordProtocol {
    public var uuid: UUID
    
    var fields: FieldsContainer<Type>
    
    public init(uuid: UUID = UUID()) {
        self.uuid = uuid
        self.fields = FieldsContainer(fields: [])
    }
    
    init(rawFields: [RawField]) {
        var fields = FieldsContainer<Type>(fields: rawFields)
        self.uuid = fields.valueForKey(Type.uuid) ?? UUID()
        fields.setValue(nil, forKey: Type.uuid)
        self.fields = fields
    }
    
    public func value<ValueType>(forKey key: FieldKey<Type, ValueType>) -> ValueType? {
        return fields.valueForKey(key)
    }
    
    public mutating func setValue<ValueType>(_ value: ValueType?, forKey key: FieldKey<Type, ValueType>) {
        fields.setValue(value, forKey: key)
    }
}

extension Record: Equatable {}
public func ==<Type>(lhs: Record<Type>, rhs: Record<Type>) -> Bool {
    return lhs.uuid == rhs.uuid
        && lhs.fields.fields == rhs.fields.fields
}