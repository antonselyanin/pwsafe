// Generated using Sourcery 0.4.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


public extension RecordProtocol where Type == Header {
    
        
    
        
    public var version: UInt16? {
        get {
            return value(forKey: Header.version)
        }
        set {
            setValue(newValue, forKey: Header.version)
        }
    }
        
    
        
    public var timestampOfLastSave: Date? {
        get {
            return value(forKey: Header.timestampOfLastSave)
        }
        set {
            setValue(newValue, forKey: Header.timestampOfLastSave)
        }
    }
        
    
        
    public var whatPerformedLastSave: String? {
        get {
            return value(forKey: Header.whatPerformedLastSave)
        }
        set {
            setValue(newValue, forKey: Header.whatPerformedLastSave)
        }
    }
        
    
        
    public var databaseName: String? {
        get {
            return value(forKey: Header.databaseName)
        }
        set {
            setValue(newValue, forKey: Header.databaseName)
        }
    }
        
    
        
    public var databaseDescription: String? {
        get {
            return value(forKey: Header.databaseDescription)
        }
        set {
            setValue(newValue, forKey: Header.databaseDescription)
        }
    }
        
    
        
    
}

public extension RecordProtocol where Type == Password {
    
        
    
        
    public var group: String? {
        get {
            return value(forKey: Password.group)
        }
        set {
            setValue(newValue, forKey: Password.group)
        }
    }
        
    
        
    public var title: String? {
        get {
            return value(forKey: Password.title)
        }
        set {
            setValue(newValue, forKey: Password.title)
        }
    }
        
    
        
    public var username: String? {
        get {
            return value(forKey: Password.username)
        }
        set {
            setValue(newValue, forKey: Password.username)
        }
    }
        
    
        
    public var notes: String? {
        get {
            return value(forKey: Password.notes)
        }
        set {
            setValue(newValue, forKey: Password.notes)
        }
    }
        
    
        
    public var password: String? {
        get {
            return value(forKey: Password.password)
        }
        set {
            setValue(newValue, forKey: Password.password)
        }
    }
        
    
        
    public var url: String? {
        get {
            return value(forKey: Password.url)
        }
        set {
            setValue(newValue, forKey: Password.url)
        }
    }
        
    
        
    public var email: String? {
        get {
            return value(forKey: Password.email)
        }
        set {
            setValue(newValue, forKey: Password.email)
        }
    }
        
    
}

