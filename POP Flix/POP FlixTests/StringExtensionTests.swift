//
//  StringExtensionTests.swift
//  POP FlixTests
//
//  Created by Renê Xavier on 28/03/19.
//  Copyright © 2019 Renefx. All rights reserved.
//

import XCTest
@testable import POP_Flix

class StringExtensionTests: XCTestCase {
    let formatter = DateFormatter()
    var dateValid: Date = Date()
    
    override func setUp() {
        formatter.dateFormat = General.dateUserDefaultFormat
        guard let date = formatter.date(from: "08-10-2019 22:31") else {
            XCTFail()
            return
        }
        dateValid = date
    }

    func testToDate() {
        let lessTwoHours = "08-10-2019 22:31"
        let result = lessTwoHours.toDateUserDefault
        
        XCTAssertEqual(result, dateValid)
    }
    
    func testToDateNil() {
        let lessTwoHours = "08-10-2019"
        let result = lessTwoHours.toDateUserDefault
        
        XCTAssertEqual(result, nil)
    }

}
