//
//  ArraySliceExtension.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 21/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

extension ArraySlice {
    func toArray() -> [Element] {
        return [Element](self)
    }
}