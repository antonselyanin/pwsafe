//
//  RawField.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 05/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public struct RawField {
    public let typeCode: UInt8
    public let bytes: [UInt8]
    
    public init(typeCode: UInt8, bytes: [UInt8]) {
        self.typeCode = typeCode
        self.bytes = bytes
    }
}

extension RawField: Equatable {}
public func ==(lhs: RawField, rhs: RawField) -> Bool {
    return lhs.typeCode == rhs.typeCode
        && lhs.bytes == rhs.bytes
}
