//
//  Record.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 03/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public protocol RecordType {
    static var uuid: FieldKey<Self, UUID> { get }

    static func key<T>(_ code: UInt8, _ serializer: ValueSerializer<T>) -> FieldKey<Self, T>

    static func listKey<T>(_ code: UInt8, _ serializer: ValueSerializer<T>) -> ListFieldKey<Self, T>
}

extension RecordType {
    public static func key<T>(_ code: UInt8, _ serializer: ValueSerializer<T>) -> FieldKey<Self, T> {
        return FieldKey(code: code, serializer: serializer)
    }

    public static func listKey<T>(_ code: UInt8, _ serializer: ValueSerializer<T>) -> ListFieldKey<Self, T> {
        return ListFieldKey(code: code, serializer: serializer)
    }
}

public protocol RecordProtocol {
    associatedtype `Type`: RecordType
    
    var uuid: UUID { get }
    
    func value<T>(forKey key: FieldKey<Type, T>) -> T?
    
    mutating func setValue<T>(_ value: T?, forKey key: FieldKey<Type, T>)
    
    func values<T>(forKey key: ListFieldKey<Type, T>) -> [T]
    
    mutating func add<T>(value: T, forKey key: ListFieldKey<Type, T>)

    mutating func remove<T>(value: T, forKey key: ListFieldKey<Type, T>)
    
    mutating func removeAll<T>(forKey key: ListFieldKey<Type, T>)
}

public struct RecordData<Type: RecordType>: RecordProtocol {
    public var uuid: UUID
    
    internal var fields: FieldsContainer<Type>
    
    internal var rawFields: [RawField] {
        var outputFields = self.fields
        outputFields.setValue(uuid, forKey: Type.uuid)
        return outputFields.fields
    }
    
    public init(uuid: UUID = UUID()) {
        self.uuid = uuid
        self.fields = FieldsContainer(fields: [])
    }
    
    public init(rawFields: [RawField]) {
        var fields = FieldsContainer<Type>(fields: rawFields)
        self.uuid = fields.valueForKey(Type.uuid) ?? UUID()
        fields.setValue(nil, forKey: Type.uuid)
        self.fields = fields
    }
    
    public func value<T>(forKey key: FieldKey<Type, T>) -> T? {
        return fields.valueForKey(key)
    }
    
    public mutating func setValue<T>(_ value: T?, forKey key: FieldKey<Type, T>) {
        fields.setValue(value, forKey: key)
    }

    public mutating func remove<T>(forKey key: FieldKey<Type, T>) {
        setValue(nil, forKey: key)
    }
    
    public func values<T>(forKey key: ListFieldKey<Type, T>) -> [T] {
        return fields.values(forKey: key)
    }
    
    public mutating func add<T>(value: T, forKey key: ListFieldKey<Type, T>) {
        fields.add(value: value, forKey: key)
    }
    
    public mutating func remove<T>(value: T, forKey key: ListFieldKey<Type, T>) {
        fields.remove(value: value, forKey: key)
    }
    
    public mutating func removeAll<T>(forKey key: ListFieldKey<Type, T>) {
        fields.removeAll(forKey: key)
    }
}

extension RecordData: Equatable {
    public static func ==<Type>(lhs: RecordData<Type>, rhs: RecordData<Type>) -> Bool {
        return lhs.uuid == rhs.uuid
            && lhs.fields.fields == rhs.fields.fields
    }
}
