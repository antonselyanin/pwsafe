PwsafeSwift is a library for reading and writing PWSAFE3 password files

```
// Open you safe
let pwsafe = try! Pwsafe(data: safeData, password: "test")
    
// Inspect the header
let header = pwsafe.header    
expect(header.version) == 0x030d
expect(header.uuid) == UUID(uuidString: "CFE1BCD4-6A0E-4BF5-8BF8-E5F1991515E2")
    
// Inspect the records
let record = pwsafe.records[0]
    
expect(record.uuid) == UUID(uuidString: "CA1051B0-B42E-6241-1656-A874D307CCD1")
expect(record.group) == Group(segments: ["group"])
expect(record.title) == "Title"
expect(record.username) == "user"
expect(record.notes) == "Notes 😜"
expect(record.password) == "password"    
```