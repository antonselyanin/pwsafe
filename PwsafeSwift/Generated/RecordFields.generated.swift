// Generated using Sourcery 0.5.5 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


public extension RecordProtocol where Type == HeaderKey {
    public var version: UInt16? {
        get {
            return value(forKey: HeaderKey.version)
        }
        set {
            setValue(newValue, forKey: HeaderKey.version)
        }
    }

    public var timestampOfLastSave: Date? {
        get {
            return value(forKey: HeaderKey.timestampOfLastSave)
        }
        set {
            setValue(newValue, forKey: HeaderKey.timestampOfLastSave)
        }
    }

    public var whatPerformedLastSave: String? {
        get {
            return value(forKey: HeaderKey.whatPerformedLastSave)
        }
        set {
            setValue(newValue, forKey: HeaderKey.whatPerformedLastSave)
        }
    }

    public var databaseName: String? {
        get {
            return value(forKey: HeaderKey.databaseName)
        }
        set {
            setValue(newValue, forKey: HeaderKey.databaseName)
        }
    }

    public var databaseDescription: String? {
        get {
            return value(forKey: HeaderKey.databaseDescription)
        }
        set {
            setValue(newValue, forKey: HeaderKey.databaseDescription)
        }
    }

}

public extension RecordProtocol where Type == RecordKey {
    public var group: Group? {
        get {
            return value(forKey: RecordKey.group)
        }
        set {
            setValue(newValue, forKey: RecordKey.group)
        }
    }

    public var title: String? {
        get {
            return value(forKey: RecordKey.title)
        }
        set {
            setValue(newValue, forKey: RecordKey.title)
        }
    }

    public var username: String? {
        get {
            return value(forKey: RecordKey.username)
        }
        set {
            setValue(newValue, forKey: RecordKey.username)
        }
    }

    public var notes: String? {
        get {
            return value(forKey: RecordKey.notes)
        }
        set {
            setValue(newValue, forKey: RecordKey.notes)
        }
    }

    public var password: String? {
        get {
            return value(forKey: RecordKey.password)
        }
        set {
            setValue(newValue, forKey: RecordKey.password)
        }
    }

    public var url: String? {
        get {
            return value(forKey: RecordKey.url)
        }
        set {
            setValue(newValue, forKey: RecordKey.url)
        }
    }

    public var email: String? {
        get {
            return value(forKey: RecordKey.email)
        }
        set {
            setValue(newValue, forKey: RecordKey.email)
        }
    }

}

