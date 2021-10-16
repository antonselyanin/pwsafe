//
//  Random.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 24/05/2018.
//  Copyright © 2018 Anton Selyanin. All rights reserved.
//

import Foundation

func generateRandomBytes(_ count: Int) throws -> [UInt8] {
    var bytes = [UInt8](repeating: 0, count: count)
    let result = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

    guard result == errSecSuccess else { throw PwsafeError.rngFailure }

    return bytes
}
