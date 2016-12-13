//
//  UUIDExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 13/12/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

extension UUID {
    init?(bytes: [UInt8]) {
        var bytesArray = bytes
        
        if bytesArray.count < 16 {
            bytesArray.append(contentsOf: [UInt8](repeating: 0, count: 16 - bytes.count))
        }
        
        self = (NSUUID(uuidBytes: bytesArray) as UUID)
    }
    
    static func toBytes(uuid: UUID) -> [UInt8] {
        var bytes = [UInt8](repeating: 0, count: 16)
        (uuid as NSUUID).getBytes(&bytes)
        return bytes
    }
}
