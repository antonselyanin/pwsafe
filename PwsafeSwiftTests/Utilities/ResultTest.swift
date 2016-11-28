//
//  ResultTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 27/11/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

class ResultTest: QuickSpec {
    override func spec() {
        describe("Result.flatMap") {
            func mapping(_ value: Int) -> Result<String> {
                return .success(String(value))
            }
            
            it("maps value") {
                // Given
                let result: Result<Int> = .success(1)
                
                // When
                let mapped: Result<String> = result.flatMap(mapping)
                
                // Then
                expect(mapped.value) == "1"
            }
            
            it("maps to failure if self is failure") {
                let error = NSError()
                
                // Given
                let result: Result<Int> = .failure(error)
                
                // When
                let mapped: Result<String> = result.flatMap(mapping)
                
                // Then
                expect(mapped.error) === error
            }
        }
    }
}
