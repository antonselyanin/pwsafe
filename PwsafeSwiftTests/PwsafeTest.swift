import Quick
import Nimble
import PwsafeSwift

class PwsafeTest: QuickSpec {
    override func spec() {
        describe("Pwsafe parsing") {
            it("should load pwsafe") {
                let safeData = NSData.loadResourceFile("test")!
                let pwsafe = try! Pwsafe(data: safeData, password: "test")
                
                let header = pwsafe.header
                
                expect(header.version).to(equal(0x030d))
                expect(header.uuid).to(equal(NSUUID(UUIDString: "CFE1BCD4-6A0E-4BF5-8BF8-E5F1991515E2")))
                
                let record = pwsafe.passwordRecords[0]
                
                expect(record.uuid).to(equal(NSUUID(UUIDString: "CA1051B0-B42E-6241-1656-A874D307CCD1")))
                expect(record.group).to(equal("group"))
                expect(record.title).to(equal("Title"))
                expect(record.username).to(equal("user"))
                expect(record.notes).to(equal("Notes 😜"))
                expect(record.password).to(equal("password"))
            }
            
            it("should throw error if password is incorrect") {
                let safeData = NSData.loadResourceFile("test")!
                do {
                    let _ = try Pwsafe(data: safeData, password: "wrong")
                } catch PwsafeError.CorruptedData {
                    // caught the correct error
                } catch let error {
                    fail("failed with error \(error)")
                }
            }
        }
        //todo: add test for failures!
        
        describe("Pwsafe creation") {
            it("should create new structure with required fields") {
                let pwsafe = Pwsafe()
                expect(pwsafe.header.uuid).notTo(beNil())
            }
        }
        
        describe("Pwsafe storing") {
            it("should create new structure with required fields") {
                var header = PwsafeHeaderRecord()
                header.uuid = NSUUID()
                header.version = 0x030b
                header.databaseName = "Database Name"
                
                var record0 = PwsafePasswordRecord()
                record0.uuid = NSUUID()
                record0.group = "group 0"
                record0.title = "title 0"
                record0.username = "username 0"
                record0.password = "password 0"

                var record1 = PwsafePasswordRecord()
                record1.uuid = NSUUID()
                record1.group = "group 1"
                record1.title = "title 1"
                record1.username = "username 1"
                record1.password = "password 1"
                
                let pwsafe = Pwsafe(header: header, passwordRecords: [record0, record1])
                
                let data = try! pwsafe.toData(withPassword: "test")
                
                let parsedPwsafe = try! Pwsafe(data: data, password: "test")
                
                expect(parsedPwsafe).to(equal(pwsafe))
            }
        }
    }
}