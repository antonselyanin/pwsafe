//
//  Hmac.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/10/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import CommonCrypto

class Hmac {
    private var context: CCHmacContext = CCHmacContext()
    
    init(key: [UInt8]) {
        CCHmacInit(&context, UInt32(kCCHmacAlgSHA256), key, key.count);
    }
    
    func update(_ data: [UInt8]) {
        CCHmacUpdate(&context, data, data.count)
    }
    
    func final() -> [UInt8] {
        var result = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmacFinal(&context, &result)
        return result
    }
}
