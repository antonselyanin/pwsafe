//
//  NSDataExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 20/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension Data {
    init(bytes: [UInt8]) {
        self.init(bytes: bytes, count: bytes.count)
    }
}
