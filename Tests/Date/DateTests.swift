//
//  DateTests.swift
//  DateTests
//
//  Created by Yusuke Ito on 3/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import XCTest
@testable import Date

class DateTests: XCTestCase {
    
    func testDate() {
        do {
            let now1 = Date()
            let nsdate = now1.nsDate
            let now2 = Date(nsdate)
            
            XCTAssertEqual(now1, now2)
            XCTAssertEqual(nsdate.timeIntervalSince1970, now2.timeintervalSince1970)
            
            XCTAssertEqual(now1.hashValue, now2.hashValue)
            
            let abs1 = now2.absoluteTime
            XCTAssertTrue(CFEqual(CFDateCreate(nil, abs1), now2.cfDate))
            let now3 = Date(absoluteTime: abs1)
            
            XCTAssertEqual(now2, now3)
            XCTAssertEqual(now1, now3)
        }
        
        do {
            let abs1 = Date(absoluteTime: 0)
            let abs2 = CFDateCreate(nil, 0)
            XCTAssertEqual(Date(abs2), abs1)
        }
    }
    
    func testDateFormatter() {
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 60*60*9)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        do {
            let nsDate = NSDate()
            let date = Date(nsDate)
            
            let formatted1 = formatter.stringFromDate(date)
            let formatted2 = formatter.stringFromDate(nsDate)
            
            XCTAssertEqual(formatted1, formatted2)
        }
        
        do {
            let dateStr = "2002-03-04 05:06:07"
            let date: Date = formatter.dateFromString(dateStr)!
            XCTAssertEqual(date.timeintervalSince1970, Double(1015185967))
            XCTAssertEqual(dateStr, formatter.stringFromDate(date))
        }
    }
    
    
    
}
