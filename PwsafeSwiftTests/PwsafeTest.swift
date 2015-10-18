import Quick
import Nimble
import PwsafeSwift

class PwsafeTest: QuickSpec {
    override func spec() {
        describe("Pwsafe") {
            it("should load pwsafe") {
                let safeUrl = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "psafe3")!
                let safeData = NSData(contentsOfURL: safeUrl)!
                
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
            
            xit("should create new structure with required fields") {
                let pwsafe = Pwsafe()
//                expect(pwsafe.header.uuid).notTo(beNil())                
            }
        }
        
        //todo: add test for failures!
    }
}