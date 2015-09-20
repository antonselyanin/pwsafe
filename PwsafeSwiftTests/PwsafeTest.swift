import Quick
import Nimble
@testable import PwsafeSwift
import CryptoSwift

class PwsafeTest: QuickSpec {
    override func spec() {
        describe("pwsafe") {
            it("should load encrypted pwsafe data") {
                let safeUrl = NSBundle(forClass: self.dynamicType).URLForResource("tom", withExtension: "psafe3")!
                let safeData = NSData(contentsOfURL: safeUrl)!
                
                var tag = [UInt8](count: 4, repeatedValue: 0)
                
                safeData.getBytes(&tag, range: NSMakeRange(0, 4))
                
                expect(tag).to(equal("PWS3".utf8Bytes()))
                
                let encryptedSafe = readPasswordSafe(safeData);
                
                expect(encryptedSafe).notTo(beNil())
                expect(encryptedSafe.eof).to(equal("PWS3-EOFPWS3-EOF".utf8Bytes()))

                let stretchedKey = stretchKey("tom".utf8Bytes(), salt:encryptedSafe.salt, iterations: Int(encryptedSafe.iter))
                
                var keyHash: [UInt8] = [UInt8](count: 32, repeatedValue: 0)
                let keyHashData = Hash.sha256(NSData(bytes: stretchedKey)).calculate()!
                keyHashData.getBytes(&keyHash, length: keyHash.count)
                
                expect(keyHash).to(equal(encryptedSafe.passwordHash))
                
                let recordsKeyCryptor = Twofish(key: stretchedKey, blockMode:CipherBlockMode.ECB)!
                let recordsKey1 = try! recordsKeyCryptor.decrypt(encryptedSafe.b1, padding:nil)
                let recordsKey2 = try! recordsKeyCryptor.decrypt(encryptedSafe.b2, padding:nil)
                let recordsKey = recordsKey1 + recordsKey2

                let recordsCryptor = Twofish(key: recordsKey, iv: encryptedSafe.iv, blockMode:CipherBlockMode.CBC)!
                
                let decryptedData = try! recordsCryptor.decrypt(encryptedSafe.encryptedData, padding: nil)
                
                let headerReader = BlockReader(data: decryptedData)
                
                let header = try! parsePwsafeHeader(headerReader)
                
                expect(header.version).to(equal(0x030b))
            }
        }
    }
}

func stretchKey(password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
    var resultData = NSData(bytes: password + salt)
    
    for _ in 0...iterations {
        resultData = Hash.sha256(resultData).calculate()!
    }
    
    var bytes: [UInt8] = [UInt8](count: 32, repeatedValue: 0)
    resultData.getBytes(&bytes, length: bytes.count)
    
    return bytes
}

func stretchKeyFast(password: [UInt8], salt: [UInt8], iterations: Int) -> [UInt8] {
    let inputData = NSMutableData(bytes: password + salt)
    var resultData = [UInt8](count:Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
    
    for _ in 0...iterations {
        CC_SHA256(inputData.bytes, UInt32(inputData.length), &resultData)
        inputData.replaceBytesInRange(NSMakeRange(0, resultData.count), withBytes: resultData);
        inputData.length = resultData.count
    }
    
    return resultData
}

private extension String {
    func utf8Bytes() -> [UInt8] {
        return utf8.map {$0}
    }
}