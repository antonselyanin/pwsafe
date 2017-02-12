//
//  PwsafeHeader.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 08/12/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import PwsafeSwift

class HeaderTest: QuickSpec {
    override func spec() {
        describe("Header") {
            
            describe("timestampOfLastSave") {
                let rfc3339DateFormatter = DateFormatter()
                rfc3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                rfc3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                rfc3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                let date = rfc3339DateFormatter.date(from: "1996-12-19T16:39:57-08:00")!

                it("gets timestamp of last save") {
                    var record: Header = Header()
                    
                    record.setValue(date, forKey: HeaderKey.timestampOfLastSave)
                    expect(record.timestampOfLastSave) == date
                }
                
                it("sets timestamp of last save") {
                    var record: Header = Header()
                    
                    record.timestampOfLastSave = date
                    expect(record.value(forKey: HeaderKey.timestampOfLastSave)) == date
                }
            }
            
            describe("emptyGroups") {
                it("gets empty groups") {
                    let group1 = "group1"
                    let group2 = "group2"
                    
                    let record: Header = Header(rawFields: [
                        RawField(typeCode: HeaderKey.emptyGroups.code, bytes: group1.utf8Bytes()),
                        RawField(typeCode: HeaderKey.emptyGroups.code, bytes: group2.utf8Bytes())
                        ])
                    
                    expect(record.emptyGroups) == [group1, group2]
                }
            }
        }
    }
}
