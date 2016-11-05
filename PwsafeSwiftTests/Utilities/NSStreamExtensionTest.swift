import Quick
import Nimble
@testable import PwsafeSwift

class NSStreamExtensionTest: QuickSpec {
    override func spec() {
        describe("NSInputStream") {
            it("should read data to array") {
                let inputData: [UInt8] = [1, 2, 3, 4, 5, 6, 7]
                let data = Data(bytes: inputData)
                let stream = InputStream(data: data)
                stream.open()
                
                expect(stream.readBytes(3)) == [1, 2, 3]
                expect(stream.readBytes(4)) == [4, 5, 6, 7]
                expect(stream.readBytes(1)).to(beNil())
            }
            
            it("should read UInt32") {
                let inputData: [UInt8] = [1, 2, 3, 4, 5, 6, 7]
                let data = Data(bytes: inputData)
                let stream = InputStream(data: data)
                stream.open()
                
                expect(stream.readUInt32()) == 0x01020304
                expect(stream.readUInt32()).to(beNil())
            }
            
            it("should read UInt32 little-endian") {
                let inputData: [UInt8] = [0x04, 0x03, 0x02, 0x01, 0xFF]
                let data = Data(bytes: inputData)
                let stream = InputStream(data: data)
                stream.open()
                
                expect(stream.readUInt32LE()) == 0x01020304
                expect(stream.readUInt32LE()).to(beNil())
            }
            
            it("should read UInt8") {
                let inputData: [UInt8] = [1, 23]
                let data = Data(bytes: inputData)
                let stream = InputStream(data: data)
                stream.open()
                
                expect(stream.readUInt8()) == 0x01
                expect(stream.readUInt8()) == 23
                expect(stream.readUInt8()).to(beNil())
            }
            
            it("should read fully") {
                let inputData:[UInt8] = [1, 2, 3, 4, 5]
                let data = Data(bytes: inputData)
                let stream = InputStream(data: data)
                stream.open()
                let _ = stream.readUInt8()
                let _ = stream.readUInt8()
                
                let tail = stream.readAllAvailable()
                expect(tail) == [3, 4, 5]
            }
        }
    }
}
