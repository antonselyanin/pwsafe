import Quick
import Nimble
@testable import PwsafeSwift
import CryptoSwift

class PwsafeParsingTest: QuickSpec {
    override func spec() {
        describe("pwsafe") {
            it("should load pwsafe") {
                let safeUrl = NSBundle(forClass: self.dynamicType).URLForResource("tom", withExtension: "psafe3")!
                let safeData = NSData(contentsOfURL: safeUrl)!
                
                let pwsafe = try! readPwsafe(safeData, password: "tom")
                expect(pwsafe.header.version).to(equal(0x030b))
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