//
//  Group.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 12/02/2017.
//  Copyright © 2017 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Group {
    public let segments: [String]
    
    public init(segments: [String]) {
        self.segments = segments
    }
    
    public func isChild(of group: Group) -> Bool {
        fatalError()
    }
    
    //func
}

extension Group: Hashable {
    public var hashValue: Int {
        let prime = 31
        return segments.reduce(0) { (result, element) in
            return result &* prime &+ element.hashValue
        }
    }
}

extension Group: Comparable {
    public static func <(lhs: Group, rhs: Group) -> Bool {
        let firstNotEqual = zip(lhs.segments, rhs.segments)
            .lazy
            .filter { (left, right) in
                return left != right
            }
            .first
        
        let result: Bool? = firstNotEqual.map({ (left, right) in left < right })
        
        return result ?? false
    }
}

extension Group: AutoEquatable {}
