//
//  File.swift
//  
//
//  Created by Anton Selyanin on 24.10.2021.
//

import Foundation

extension Result {
    var value: Success? {
        try? get()
    }
}
