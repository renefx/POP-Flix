//
//  DateExtensionTestes.swift
//  POP FlixTests
//
//  Created by Renê Xavier on 28/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import XCTest
@testable import POP_Flix

class DateExtensionTestes: XCTestCase {
    let formatter = DateFormatter()
    var dateTest: Date = Date()

    override func setUp() {
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let date = formatter.date(from: "2019/10/08 22:31") else {
            XCTFail()
            return
        }
        dateTest = date
    }

    func testRemoveHour() {
        let dateChanged = dateTest.removeHour(numberOfHours: 2)
        let result = formatter.string(from: dateChanged)
        let lessTwoHours = "2019/10/08 20:31"
        XCTAssertEqual(result, lessTwoHours)
    }
    
    func testHourMinutes() {
        let result = dateTest.hourMinutes
        let hourMin = "22:31"
        XCTAssertEqual(result, hourMin)
    }
    
    func testToString() {
        let result = dateTest.toString(General.dateUserDefaultFormat)
        let hourMin = "08-10-2019 22:31"
        XCTAssertEqual(result, hourMin)
    }

}
