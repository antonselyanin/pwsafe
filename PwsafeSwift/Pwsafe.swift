//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 02/08/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

public struct Pwsafe {
    public internal(set) var header: HeaderRecord
    public internal(set) var passwordRecords: [PasswordRecord]
    
    public init(header: HeaderRecord = HeaderRecord(uuid: UUID()), passwordRecords: [PasswordRecord] = []) {
        self.header = header
        self.passwordRecords = passwordRecords
    }
    
    public subscript(uuid: UUID) -> PasswordRecord? {
        get {
            return passwordRecords
                .lazy
                .filter({ $0.uuid == uuid })
                .first
        }
        
        set {
            let index = passwordRecords.index(where: { $0.uuid == uuid })
            
            if let newValue = newValue {
                if let index = index {
                    passwordRecords[index] = newValue
                } else {
                    passwordRecords.append(newValue)
                }
            } else {
                if let index = index {
                    passwordRecords.remove(at: index)
                }
            }
        }
    }
    
    public mutating func addOrUpdateRecord(_ record: PasswordRecord) {
        self[record.uuid] = record
    }
}

extension Pwsafe: Equatable {}
public func ==(lhs: Pwsafe, rhs: Pwsafe) -> Bool {
    return lhs.header == rhs.header
        && lhs.passwordRecords == rhs.passwordRecords
}
