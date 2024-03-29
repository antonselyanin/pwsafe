//
//  StringExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 20/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension String {
    func utf8Bytes() -> [UInt8] {
        return Array(utf8)
    }
}
