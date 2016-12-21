//
//  SafeUpdater.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 19/12/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation

public class SafeUpdater {
    private static let defaultSaver: String = "PwsafeSwift"
    
    public private(set) var safe: Pwsafe
    
    public init(safe: Pwsafe) {
        self.safe = safe
    }
    
    public func dontUpgradeVersion() -> SafeUpdater {
        return self
    }
    
    public func set(lastSaveDate: Date) -> SafeUpdater {
        return self
    }
    
    public func set(whatPerformedSave: String) -> SafeUpdater {
        return self
    }
    
    public func removePassword(by: UUID) -> SafeUpdater {
        return self
    }
    
    public func add(password: PasswordRecord) -> SafeUpdater {
        return self
    }
    
    public func updated() -> Pwsafe {
        safe.header.setIfNil(forKey: Header.version, value: Pwsafe.defaultFormatVersion)
        safe.header.setIfNil(forKey: Header.whatPerformedLastSave, value: Pwsafe.defaultSaver)
        safe.header.setIfNil(forKey: Header.timestampOfLastSave, value: Date())
        
        return safe
    }
}

extension RecordProtocol {
    //TODO: ugly name
    internal mutating func setIfNil<FieldType>(forKey key: FieldKey<Type, FieldType>, value fieldValue: FieldType) {
        guard value(forKey: key) == nil else { return }
        
        setValue(fieldValue, forKey: key)
    }
}
