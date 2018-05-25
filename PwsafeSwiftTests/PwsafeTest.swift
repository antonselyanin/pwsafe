import Quick
import Nimble
import PwsafeSwift

class PwsafeTest: QuickSpec {
    override func spec() {
        describe("Pwsafe parsing") {
            it("should load pwsafe") {
                let safeData = Data.loadResourceFile("test")!
                let pwsafe = try! Pwsafe(data: safeData, password: "test")
                
                let header = pwsafe.header
                
                expect(header.version) == 0x030d
                expect(header.uuid) == UUID(uuidString: "CFE1BCD4-6A0E-4BF5-8BF8-E5F1991515E2")
                
                let record = pwsafe.records[0]
                
                expect(record.uuid) == UUID(uuidString: "CA1051B0-B42E-6241-1656-A874D307CCD1")
                expect(record.group) == Group(segments: ["group"])
                expect(record.title) == "Title"
                expect(record.username) == "user"
                expect(record.notes) == "Notes 😜"
                expect(record.password) == "password"
            }
            
            it("should throw error if password is incorrect") {
                let safeData = Data.loadResourceFile("test")!
                do {
                    let _ = try Pwsafe(data: safeData, password: "wrong")
                } catch PwsafeError.corruptedData {
                    // caught the correct error
                } catch let error {
                    fail("failed with error \(error)")
                }
            }
        }
        
        //todo: add test for failures!
        
        describe("Pwsafe storing") {
            it("should create new structure with required fields") {
                var header = Header(uuid: UUID())
                header.version = 0x030b
                header.databaseName = "Database Name"
                
                var record0 = Record(uuid: UUID())
                record0.group = Group(segments: ["group 0"])
                record0.title = "title 0"
                record0.username = "username 0"
                record0.password = "password 0"

                var record1 = Record(uuid: UUID())
                record1.group = Group(segments: ["group 1"])
                record1.title = "title 1"
                record1.username = "username 1"
                record1.password = "password 1"
                
                let pwsafe = Pwsafe(header: header, records: [record0, record1])
                
                let data = try! pwsafe.toData(with: "test")
                
                let parsedPwsafe = try! Pwsafe(data: data, password: "test")
                
                expect(parsedPwsafe) == pwsafe
            }
        }
        
        describe("accessing records by UUID") {
            let recordUUID0 = UUID()
            let recordUUID1 = UUID()
            
            var header = Header(uuid: UUID())
            header.version = 0x030b
            header.databaseName = "Database Name"
            
            var record0 = Record(uuid: recordUUID0)
            record0.group = Group(segments: ["group 0"])
            record0.title = "title 0"
            record0.username = "username 0"
            record0.password = "password 0"
            
            var record1 = Record(uuid: recordUUID1)
            record1.group = Group(segments: ["group 1"])
            record1.title = "title 1"
            record1.username = "username 1"
            record1.password = "password 1"

            it("should get records by UUID") {
                let pwsafe = Pwsafe(header: header, records: [record0])
                expect(pwsafe[recordUUID0]) == record0
            }
            
            it("should add new record with UUID") {
                var pwsafe = Pwsafe(header: header, records: [record0])
                pwsafe[recordUUID1] = record1
                expect(pwsafe[recordUUID1]) == record1
            }

            it("should update record") {
                var updateRecord = Record(uuid: recordUUID0)
                updateRecord.group = Group(segments: ["update group"])
                updateRecord.title = "update title"
                updateRecord.username = "update username"
                updateRecord.password = "update username"

                var pwsafe = Pwsafe(header: header, records: [record0])
                pwsafe[recordUUID0] = updateRecord
                
                expect(pwsafe[recordUUID0]) == updateRecord
            }
            
            it("should remove record") {
                var pwsafe = Pwsafe(header: header, records: [record0])
                pwsafe[recordUUID0] = nil
                
                expect(pwsafe[recordUUID0]).to(beNil())
            }
        }
        
        describe("querying records by groups") {
            let group0 = Group(segments: ["level0"])
            let group1 = Group(segments: ["level1"])
            
            var record0: Record!
            var record1: Record!
            
            beforeEach {
                record0 = Record()
                record1 = Record()
            }
            
            it("returns groups for records") {
                record0.group = group0
                record1.group = group1
                
                let pwsafe = Pwsafe(records: [record0, record1])
                
                expect(pwsafe.groups) == [group0, group1]
            }
            
            it("returns unique groups for records") {
                record0.group = group0
                record1.group = group0
                
                let pwsafe = Pwsafe(records: [record0, record1])
                
                expect(pwsafe.groups) == [group0]
            }
            
            it("returns all groups safe") {
                record0.group = group0
                record1.group = group0
                
                let emptyGroup = Group(segments: ["empty0"])
                
                var header = Header()
                header.addEmptyGroup(emptyGroup)
                
                let pwsafe = Pwsafe(header: header, records: [record0, record1])
                
                expect(pwsafe.groups) == [emptyGroup, group0]
            }
        }
        
        describe("querying records by groups 2") {
            let group1 = Group(segments: ["level1"])
            let group2 = Group(segments: ["level2"])
            let group3 = Group(segments: ["level1", "level11"])
            
            var record0 = Record()
            record0.group = group1
            
            var record1 = Record()
            record1.group = group2
            
            var record2 = Record()
            record2.group = group3
            
            let pwsafe = Pwsafe(records: [record0, record1, record2])
            
            it("returns records from group") {
                expect(pwsafe.records(in: group1)) == [record0]
                expect(pwsafe.records(in: group2)) == [record1]
            }
            
            it("returns all records for root group") {
                expect(pwsafe.records(in: Pwsafe.rootGroup)) == [record0, record1, record2]
            }
        }
        
        describe("group tree") {
            it("walks tree") {
                let groups: [Group] = [
                    Group(segments: ["level 1", "level 1:1", "level 1:1:1"]),
                    Group(segments: ["level 1", "level 1:2"])
                ]
                
                var header = Header()
                
                for group in groups {
                    header.addEmptyGroup(group)
                }
                
                let pwsafe = Pwsafe(header: header)
                
                let level1 = pwsafe.subgroups(at: Pwsafe.rootGroup)
                expect(level1.count) == 1
                expect(level1[0].segments) == ["level 1"]
                
                let level2 = pwsafe.subgroups(at: level1[0])
                expect(level2.count) == 2
                expect(level2[0].segments) == ["level 1", "level 1:1"]
                expect(level2[1].segments) == ["level 1", "level 1:2"]
                
                let level31 = pwsafe.subgroups(at: level2[0])
                expect(level31.count) == 1
                expect(level31[0].segments) == ["level 1", "level 1:1", "level 1:1:1"]
                
                let level32 = pwsafe.subgroups(at: level2[1])
                expect(level32.isEmpty) == true
            }
        }

    }
}
