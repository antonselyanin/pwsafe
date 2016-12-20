//
//  SafeUpdaterTest.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 20/12/2016.
//  Copyright © 2016 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
import PwsafeSwift

class SafeUpdaterTest: QuickSpec {
    override func spec() {
        describe("SafeUpdater for empty safe") {
            it("sets default header values") {
                let updater = SafeUpdater(safe: Pwsafe())
                let result = updater.updated()
                
                let header = result.header
                
                expect(header.version) == Pwsafe.defaultFormatVersion
                expect(header.whoPerformedLastSave) == Pwsafe.defaultSaver
                expect(header.whatPerformedLastSave) == Pwsafe.defaultSaver
                expect(header.timestampOfLastSave).notTo(beNil())                
            }
        }
    }
}
