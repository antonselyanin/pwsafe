//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 27/09/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

enum PwsafeHeaderFieldType: UInt8 {
    case Version = 0x00
    case UUID = 0x01
    case NonDefaultPreferences = 0x03
    case TreeDisplayStatus = 0x04
    case WhoPerformedLastSave = 0x05 // deprecated by the specification
    case WhatPerformedLastSave = 0x06
    case LastSavedByUser = 0x07
    case LastSavedOnHost = 0x08
    case DatabaseName = 0x09
    case DatabaseDescription = 0x0a
    case DatabaseFilters = 0x0b
    case Reserved1 = 0x0c
    case Reserved2 = 0x0d
    case Reserved3 = 0x0e
    case RecentlyUsedEntries = 0x0f
    case NamedPasswordPolicies = 0x10
    case EmptyGroups = 0x11
    case Yubico = 0x12
}

public extension PwsafeHeaderRecord {
    public static let Version = key(.Version, extractor: uint16Extractor)
    public static let UUID = key(.UUID, extractor: uuidExtractor)
    public static let WhatPerformedLastSave = key(.WhatPerformedLastSave, extractor: stringExtractor)
    public static let DatabaseName = key(.DatabaseName, extractor: stringExtractor)
    public static let DatabaseDescription = key(.DatabaseDescription, extractor: stringExtractor)
}

public extension PwsafeHeaderRecord {
    public var version: UInt16? {
        return valueByKey(PwsafeHeaderRecord.Version)
    }
    
    public var uuid: NSUUID? {
        return valueByKey(PwsafeHeaderRecord.UUID)
    }
    
    public var databaseName: String? {
        return valueByKey(PwsafeHeaderRecord.DatabaseName)
    }
}

private func key<T>(code: PwsafeHeaderFieldType, extractor: (bytes: [UInt8]) -> T?) -> FieldKey<PwsafeHeaderRecord, T> {
    return FieldKey<PwsafeHeaderRecord, T>(code: code.rawValue, extractor: extractor)
}

