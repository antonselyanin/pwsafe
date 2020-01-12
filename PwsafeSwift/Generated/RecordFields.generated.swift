// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


public extension RecordProtocol where Type == HeaderKey {
    var version: UInt16? {
        get {
            return value(forKey: HeaderKey.version)
        }
        set {
            setValue(newValue, forKey: HeaderKey.version)
        }
    }

    var timestampOfLastSave: Date? {
        get {
            return value(forKey: HeaderKey.timestampOfLastSave)
        }
        set {
            setValue(newValue, forKey: HeaderKey.timestampOfLastSave)
        }
    }

    var whatPerformedLastSave: String? {
        get {
            return value(forKey: HeaderKey.whatPerformedLastSave)
        }
        set {
            setValue(newValue, forKey: HeaderKey.whatPerformedLastSave)
        }
    }

    var databaseName: String? {
        get {
            return value(forKey: HeaderKey.databaseName)
        }
        set {
            setValue(newValue, forKey: HeaderKey.databaseName)
        }
    }

    var databaseDescription: String? {
        get {
            return value(forKey: HeaderKey.databaseDescription)
        }
        set {
            setValue(newValue, forKey: HeaderKey.databaseDescription)
        }
    }

}

public extension RecordProtocol where Type == RecordKey {
    var group: Group? {
        get {
            return value(forKey: RecordKey.group)
        }
        set {
            setValue(newValue, forKey: RecordKey.group)
        }
    }

    var title: String? {
        get {
            return value(forKey: RecordKey.title)
        }
        set {
            setValue(newValue, forKey: RecordKey.title)
        }
    }

    var username: String? {
        get {
            return value(forKey: RecordKey.username)
        }
        set {
            setValue(newValue, forKey: RecordKey.username)
        }
    }

    var notes: String? {
        get {
            return value(forKey: RecordKey.notes)
        }
        set {
            setValue(newValue, forKey: RecordKey.notes)
        }
    }

    var password: String? {
        get {
            return value(forKey: RecordKey.password)
        }
        set {
            setValue(newValue, forKey: RecordKey.password)
        }
    }

    var url: String? {
        get {
            return value(forKey: RecordKey.url)
        }
        set {
            setValue(newValue, forKey: RecordKey.url)
        }
    }

    var email: String? {
        get {
            return value(forKey: RecordKey.email)
        }
        set {
            setValue(newValue, forKey: RecordKey.email)
        }
    }

    var creditCardNumber: String? {
        get {
            return value(forKey: RecordKey.creditCardNumber)
        }
        set {
            setValue(newValue, forKey: RecordKey.creditCardNumber)
        }
    }

    var creditCardExpiration: String? {
        get {
            return value(forKey: RecordKey.creditCardExpiration)
        }
        set {
            setValue(newValue, forKey: RecordKey.creditCardExpiration)
        }
    }

    var creditCardVerificationValue: String? {
        get {
            return value(forKey: RecordKey.creditCardVerificationValue)
        }
        set {
            setValue(newValue, forKey: RecordKey.creditCardVerificationValue)
        }
    }

    var creditCardPin: String? {
        get {
            return value(forKey: RecordKey.creditCardPin)
        }
        set {
            setValue(newValue, forKey: RecordKey.creditCardPin)
        }
    }

}

