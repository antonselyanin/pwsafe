//
//  PwsafeHeaderRecord.swift
//  PwsafeSwift
//
//  Created by Anton Selyanin on 08/12/15.
//  Copyright © 2015 Anton Selyanin. All rights reserved.
//

import Foundation

import Quick
import Nimble
import PwsafeSwift

class HeaderRecordTest: QuickSpec {
    override func spec() {
        describe("HeaderRecord") {
            
            describe("timestampOfLastSave") {
                let rfc3339DateFormatter = DateFormatter()
                rfc3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                rfc3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                rfc3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                let date = rfc3339DateFormatter.date(from: "1996-12-19T16:39:57-08:00")!

                it("gets timestamp of last save") {
                    var record: HeaderRecord = HeaderRecord()
                    
                    record.setValue(date, forKey: Header.timestampOfLastSave)
                    expect(record.timestampOfLastSave) == date
                }
                
                it("sets timestamp of last save") {
                    var record: HeaderRecord = HeaderRecord()
                    
                    record.timestampOfLastSave = date
                    expect(record.value(forKey: Header.timestampOfLastSave)) == date
                }
            }
        }
    }
}
