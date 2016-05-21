//
//  FieldKey.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 5/21/16.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public struct FieldKey<RecordType, Value> {
    public let code: UInt8
    public let serializer: ValueSerializer<Value>
}
