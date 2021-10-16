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

    func testTwofish_encrypt_decrypt_128bit_key() throws {
        let keyArray:[UInt8] = [UInt8](repeating: 0, count: 16)
        let cryptor = try Twofish(key: keyArray, blockMode: ECBMode())
        
        let pt = [UInt8](repeating: 0, count: 16)
        let ct = try cryptor.encrypt(pt)
        let expectedCT:[UInt8] = [0x9F, 0x58, 0x9F, 0x5C, 0xF6, 0x12, 0x2C, 0x32, 0xB6, 0xBF, 0xEC, 0x2F, 0x2A, 0xE8, 0xC3, 0x5A]
        XCTAssertEqual(ct, expectedCT, "encryption failed")
        
        let pt2 = try cryptor.decrypt(ct)
        let expectedPT = [UInt8](repeating: 0, count: 16)
        XCTAssertEqual(pt2, expectedPT, "encryption failed")
    }
    
    
    func testTwofish_encrypt_decrypt_256bit_key() throws {
        let keyArray:[UInt8] = [UInt8](repeating: 0, count: 32)
        let cryptor = try! Twofish(key: keyArray, blockMode: ECBMode())
        
        let pt = [UInt8](repeating: 0, count: 16)
        let ct = try cryptor.encrypt(pt)
        let expectedCT:[UInt8] = [0x57, 0xFF, 0x73, 0x9D, 0x4D, 0xC9, 0x2C, 0x1B, 0xD7, 0xFC, 0x01, 0x70, 0x0C, 0xC8, 0x21, 0x6F]
        XCTAssertEqual(ct, expectedCT, "encryption failed")
        
        let pt2 = try cryptor.decrypt(ct)
        let expectedPT = [UInt8](repeating: 0, count: 16)
        XCTAssertEqual(pt2, expectedPT, "encryption failed")
    }

    func testTwofish_sample_data() throws {
        let safeUrl = Bundle.module.url(forResource: "ECB_TBL", withExtension: "TXT")!
        let data = try! String(contentsOf: safeUrl)
        let items = data.components(separatedBy: "I=")
        let testSamples = items.map(parseKeyValue).map(parseTestData).compactMap { $0 }
        
        for testData in testSamples {
            let cryptor = try Twofish(key: testData.key, blockMode: ECBMode())
            
            let ct = try cryptor.encrypt(testData.plainText)
            XCTAssertEqual(ct, testData.cipherText, "encryption failed for sample \(testData.id)")
            
            let pt = try cryptor.decrypt(testData.cipherText)
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

func hexStringToUInt8Array(_ input: String) -> [UInt8] {
    var result = [UInt8]()
    
    for i in stride(from: 0, to: input.count, by: 2) {
        let range = input.index(input.startIndex, offsetBy: i)...input.index(input.startIndex, offsetBy: i + 1)
        if let value = UInt8(String(input[range]), radix: 16) {
            result.append(value)
        }
    }
    
    return result;
}

func parseKeyValue(_ input: String) -> [String:String] {
    return ("I=" + input).components(separatedBy: "\r\n").reduce([String: String]()) {
        (record, line) in
        var outputRecord = record
        
        if let splitIndex = line.firstIndex(of: "=") {
            let key = String(line.prefix(upTo: splitIndex))
            let value = String(line.suffix(from: line.index(after: splitIndex)))
            outputRecord[key] = value
        }
        
        return outputRecord
    }
}

func parseTestData(_ record: [String:String]) -> TwofishTestData? {
    guard let id = record["I"], let key = record["KEY"], let ct = record["CT"], let pt = record["PT"] else {
        return nil
    }
    
    return TwofishTestData(
        id: id,
        key: hexStringToUInt8Array(key),
        cipherText: hexStringToUInt8Array(ct),
        plainText: hexStringToUInt8Array(pt)
    )
}
