//
//  Pwsafe.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Pwsafe {
    public static let defaultFormatVersion: UInt16 = 0x030d
    public static let defaultSaver: String = "PwsafeKit library for Swift"
    
    public var header: Header
    public internal(set) var records: [Record]
    
    public init(header: Header = Header(uuid: UUID()),
                records: [Record] = []) {
        self.header = header
        self.records = records
    }
    
    public subscript(uuid: UUID) -> Record? {
        get {
            return records
                .lazy
                .filter({ $0.uuid == uuid })
                .first
        }
        
        set {
            let index = records.index(where: { $0.uuid == uuid })
            
            if let newValue = newValue {
                if let index = index {
                    records[index] = newValue
                } else {
                    records.append(newValue)
                }
            } else {
                if let index = index {
                    records.remove(at: index)
                }
            }
        }
    }
}

extension Pwsafe: Equatable {
    public static func ==(lhs: Pwsafe, rhs: Pwsafe) -> Bool {
        return lhs.header == rhs.header
            && lhs.records == rhs.records
    }
}
