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
    
    public static let rootGroup: Group = Group(segments: [])
    
    public var header: Header
    public internal(set) var records: [Record]
    
    public var groups: [Group] {
        return (records.flatMap({ $0.group }) + header.emptyGroups).uniqueSorted(by: <)
    }
    
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
            
            switch (index, newValue) {
            case (let index?, let newValue?):
                records[index] = newValue
                
            case (let index?, nil):
                records.remove(at: index)
                
            case (nil, let newValue?):
                records.append(newValue)
            
            case (nil, nil):
                break
            }
        }
    }
    
    public func subgroups(at level: Group) -> [Group] {
        let subgroups: [String] = groups
            .filter({ $0.segments.starts(with: level.segments) })
            .flatMap { group in
                let segments = group.segments.suffix(group.segments.count - level.segments.count)
                return segments.first
            }
        
        let result = subgroups.uniqueSorted(by: <)
        return result.map { segment in
            return Group(segments: level.segments + [segment])
        }
    }
    
    public func records(in group: Group) -> [Record] {
        guard group != Pwsafe.rootGroup else { return records }
        
        return records.filter({ $0.group == group })
    }
}

extension Pwsafe: AutoEquatable {}
