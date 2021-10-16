//
//  FieldKey.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 5/21/16.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public protocol FieldCode {
    var code: UInt8 { get }
}

public struct FieldKey<RecordType, Value>: FieldCode {
    public let code: UInt8
    /// sourcery: skipEquality
    public let serializer: ValueSerializer<Value>
}

public struct ListFieldKey<RecordType, Value>: FieldCode {
    public let code: UInt8
    public let serializer: ValueSerializer<Value>
}
