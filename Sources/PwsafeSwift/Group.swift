//
//  Group.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/02/2017.
//  Copyright © 2017 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Group: Hashable {
    public let segments: [String]
    
    public init(segments: [String]) {
        self.segments = segments
    }

    public var title: String? {
        return segments.last
    }
}

extension Group: Comparable {
    public static func <(lhs: Group, rhs: Group) -> Bool {
        let firstNotEqual = zip(lhs.segments, rhs.segments)
            .first(where: { $0.0 != $0.1 })
        
        let result: Bool? = firstNotEqual.map { $0.0 < $0.1 }
        
        return result ?? false
    }
}
