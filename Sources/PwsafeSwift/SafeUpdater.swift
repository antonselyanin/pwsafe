//
//  SafeUpdater.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/12/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public struct SafeUpdater {
    private static let defaultSaver: String = "PwsafeSwift"
    
    public private(set) var safe: Pwsafe
    
    public init(safe: Pwsafe) {
        self.safe = safe
    }
    
//    public func dontUpgradeVersion() -> SafeUpdater {
//        return self
//    }
//    
//    public func set(lastSaveDate: Date) -> SafeUpdater {
//        return self
//    }
//    
//    public func set(whatPerformedSave: String) -> SafeUpdater {
//        return self
//    }
//    
//    public func removePassword(by: UUID) -> SafeUpdater {
//        return self
//    }
//    
//    public func add(record: Record) -> SafeUpdater {
//        return self
//    }
    
    public func updated() -> Pwsafe {
        var resultSafe = safe
        
        resultSafe.header.setIfNil(forKey: HeaderKey.version, value: Pwsafe.defaultFormatVersion)
        resultSafe.header.setIfNil(forKey: HeaderKey.whatPerformedLastSave, value: Pwsafe.defaultSaver)
        resultSafe.header.setIfNil(forKey: HeaderKey.timestampOfLastSave, value: Date())
        
        return resultSafe
    }
}

extension RecordProtocol {
    //TODO: ugly name
    internal mutating func setIfNil<FieldType>(forKey key: FieldKey<Type, FieldType>, value fieldValue: FieldType) {
        guard value(forKey: key) == nil else { return }
        
        setValue(fieldValue, forKey: key)
    }
}
