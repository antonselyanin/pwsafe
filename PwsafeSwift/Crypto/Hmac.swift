//
//  Hmac.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

class Hmac {
    var context: CCHmacContext = CCHmacContext()
    
    init(key: [UInt8]) {
        CCHmacInit(&context, UInt32(kCCHmacAlgSHA256), key, key.count);
    }
    
    func update(data: [UInt8]) {
        CCHmacUpdate(&context, data, data.count)
    }
    
    func final() -> [UInt8] {
        var result = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CCHmacFinal(&context, &result)
        return result
    }
}