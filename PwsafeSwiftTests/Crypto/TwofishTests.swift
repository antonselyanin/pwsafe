//
//  TwofishTests.swift
//  CryptoSwift
//
//  Created by Anton Selyanin on 13/08/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation
import XCTest
@testable import PwsafeSwift

final class TwofishTests: XCTestCase {

    func testTwofish_encrypt_decrypt_128bit_key() {
        let keyArray:[UInt8] = [UInt8](count: 16, repeatedValue: 0)
        let cryptor = Twofish(key: keyArray, blockMode: ECBMode())!
        
        let pt = [UInt8](count: 16, repeatedValue: 0)
        let ct = try! cryptor.encrypt(pt)
        let expectedCT:[UInt8] = [0x9F, 0x58, 0x9F, 0x5C, 0xF6, 0x12, 0x2C, 0x32, 0xB6, 0xBF, 0xEC, 0x2F, 0x2A, 0xE8, 0xC3, 0x5A]
        XCTAssertEqual(ct, expectedCT, "encryption failed")
        
        let pt2 = try! cryptor.decrypt(ct)
        let expectedPT = [UInt8](count: 16, repeatedValue: 0)
        XCTAssertEqual(pt2, expectedPT, "encryption failed")
    }
    
    
    func testTwofish_encrypt_decrypt_256bit_key() {
        let keyArray:[UInt8] = [UInt8](count: 32, repeatedValue: 0)
        let cryptor = Twofish(key: keyArray, blockMode: ECBMode())!
        
        let pt = [UInt8](count: 16, repeatedValue: 0)
        let ct = try! cryptor.encrypt(pt)
        let expectedCT:[UInt8] = [0x57, 0xFF, 0x73, 0x9D, 0x4D, 0xC9, 0x2C, 0x1B, 0xD7, 0xFC, 0x01, 0x70, 0x0C, 0xC8, 0x21, 0x6F]
        XCTAssertEqual(ct, expectedCT, "encryption failed")
        
        let pt2 = try! cryptor.decrypt(ct)
        let expectedPT = [UInt8](count: 16, repeatedValue: 0)
        XCTAssertEqual(pt2, expectedPT, "encryption failed")
    }

    func testTwofish_sample_data() {
        let safeUrl = NSBundle(forClass: self.dynamicType).URLForResource("ECB_TBL", withExtension: "TXT")
        let data = try! String(contentsOfURL: safeUrl!)
        let items = data.componentsSeparatedByString("I=")
        let testSamples = items.map(parseKeyValue).map(parseTestData).flatMap { $0 }
        
        for testData in testSamples {
            let cryptor = Twofish(key: testData.key, blockMode: ECBMode())!
            
            let ct = try! cryptor.encrypt(testData.plainText)
            XCTAssertEqual(ct, testData.cipherText, "encryption failed for sample \(testData.id)")
            
            let pt = try! cryptor.decrypt(testData.cipherText)
            XCTAssertEqual(pt, testData.plainText, "decryption failed for sample \(testData.id)")
        }
    }

}

struct TwofishTestData {
    let id: String
    let key: [UInt8]
    let cipherText: [UInt8]
    let plainText: [UInt8]
}

func hexStringToUInt8Array(input: String) -> [UInt8] {
    var result = [UInt8]()
    
    for i in 0.stride(to: input.characters.count, by: 2) {
        let range = input.startIndex.advancedBy(i)...input.startIndex.advancedBy(i + 1)
        if let value = UInt8(input[range], radix: 16) {
            result.append(value)
        }
    }
    
    return result;
}

func parseKeyValue(input: String) -> [String:String] {
    return ("I=" + input).componentsSeparatedByString("\r\n").reduce([String:String]()) {
        (record, line) in
        var outputRecord = record
        
        if let splitIndex = line.characters.indexOf("=") {
            let key = String(line.characters.prefixUpTo(splitIndex))
            let value = String(line.characters.suffixFrom(splitIndex.successor()))
            outputRecord[key] = value
        }
        
        return outputRecord
    }
}

func parseTestData(record: [String:String]) -> TwofishTestData? {
    if let id = record["I"], key = record["KEY"], ct = record["CT"], pt = record["PT"] {
        return TwofishTestData(
            id: id,
            key: hexStringToUInt8Array(key),
            cipherText: hexStringToUInt8Array(ct),
            plainText: hexStringToUInt8Array(pt)
        )
    }
    
    return nil
}