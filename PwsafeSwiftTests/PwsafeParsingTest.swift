import Quick
import Nimble
@testable import PwsafeSwift

class PwsafeParsingTest: QuickSpec {
    override func spec() {
        describe("pwsafe") {
            it("should load pwsafe") {
                let safeUrl = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "psafe3")!
                let safeData = NSData(contentsOfURL: safeUrl)!
                
                let pwsafe = try! readPwsafe(safeData, password: "test")
                
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
        }
        
        //todo: add test for failures!
        
        describe("parseRawPwsafeRecords") {
            it ("should multiple records") {
                //setup
                var writer = BlockWriter()
                writer.writeRawField(type: 1, data: [1, 2, 3, 4])
                writer.writeRawField(type: 2, data: [5, 6, 7])
                writer.writeRawField(type: 0xff)
                
                writer.writeRawField(type: 1, data: [1, 2, 3, 4])
                writer.writeRawField(type: 5)
                writer.writeRawField(type: 5)
                writer.writeRawField(type: 0xff)
                
                let rawRecords = try! parseRawPwsafeRecords(writer.data)
                
                //assert
                expect(rawRecords.count).to(equal(2))

                let record1 = rawRecords[0]
                expect(record1.count).to(equal(2))
                expect(record1[0].typeCode).to(equal(1))
                expect(record1[0].bytes).to(equal([1, 2, 3, 4]))
                expect(record1[1].typeCode).to(equal(2))
                expect(record1[1].bytes).to(equal([5, 6, 7]))
                
                let record2 = rawRecords[1]
                expect(record2.count).to(equal(3))
                expect(record2[0].typeCode).to(equal(1))
                expect(record2[0].bytes).to(equal([1, 2, 3, 4]))
                expect(record2[1].typeCode).to(equal(5))
                expect(record2[1].bytes).to(equal([]))
                expect(record2[2].typeCode).to(equal(5))
                expect(record2[2].bytes).to(equal([]))
            }
        }
    }
}