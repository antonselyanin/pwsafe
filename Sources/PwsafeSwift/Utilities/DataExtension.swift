//
//  DataExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 11/02/2017.
//  Copyright © 2017 Anton Selyanin. All rights reserved.
//

import Foundation

extension Data {
    func suffixData(_ maxLength: Int) -> Data {
        guard maxLength < count else { return self }
        
        let length = maxLength
        let start = count - length
        let end = start + length
        return subdata(in: start..<end)
    }
    
    func prefixData(_ maxLength: Int) -> Data {
        guard maxLength < count else { return self }
        
        return subdata(in: 0..<maxLength)
    }
}
