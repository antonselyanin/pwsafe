//
//  NSDataExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 11/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension NSData {
    convenience init(bytes:[UInt8]) {
        self.init(bytes: bytes, length:bytes.count)
    }
}

extension NSData {
    static func loadResourceFile(resource: String) -> NSData? {
        let safeUrl = NSBundle(forClass: PwsafeTest.self).URLForResource(resource, withExtension: "psafe3")!
        return NSData(contentsOfURL: safeUrl)
    }
}