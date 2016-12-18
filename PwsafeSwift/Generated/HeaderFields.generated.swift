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
