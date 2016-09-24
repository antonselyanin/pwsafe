//
//  NSDataExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 11/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
//@testable import PwsafeSwift

// import from PwsafeSwift
extension Data {
    init(bytes: [UInt8]) {
        self.init(bytes: bytes, count: bytes.count)
    }
}

extension Data {
    static func loadResourceFile(_ resource: String) -> Data? {
        let safeUrl = Bundle(for: PwsafeTest.self).url(forResource: resource, withExtension: "psafe3")!
        return (try? Data(contentsOf: safeUrl))
    }
}
