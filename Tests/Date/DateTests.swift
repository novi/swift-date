//
//  DateTests.swift
//  DateTests
//
//  Created by Yusuke Ito on 3/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import XCTest
@testable import Date
import Foundation
import CoreFoundation

extension DateTests {
    static var allTests : [(String, DateTests -> () throws -> Void)] {
        return [
                   ("testDate", testDate),
                   ("testComparing", testComparing),
                   ("testOperation", testOperation),
                   ("testJSTDateFormatter", testJSTDateFormatter),
                   ("testUTCDateFormatter", testUTCDateFormatter),
                   ("testNSDateFormatter", testNSDateFormatter)
        ]
    }
}

class DateTests: XCTestCase {
    
    func testDate() {
        do {
            let now1 = Date()
            let nsdate = now1.nsDate
            let now2 = Date(nsdate)
            
            XCTAssertEqual(now1, now2)
            XCTAssertEqual(nsdate.timeIntervalSince1970, now2.timeIntervalSince1970)
            
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
        
        do {
            let date = Date(since1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            XCTAssertEqual(date.timeIntervalSince1970, 1458117192)
        }
    }
    
    func testComparing() {
        
        let now1 = Date(absoluteTime: 0)
        let now2 = Date(absoluteTime: 0)
        XCTAssertTrue(now1 == now2)
        XCTAssertTrue(now1 >= now2)
        XCTAssertTrue(now1 <= now2)
        
    }
    
    func testOperation() {
        let now = Date()
        let sinceNow = now + 60
        XCTAssertEqual(now.timeIntervalSince1970 + 60, sinceNow.timeIntervalSince1970)
        
        XCTAssertEqual((now - 54).timeIntervalSince1970, now.timeIntervalSince1970 - 54)
        
        XCTAssertEqual(now - sinceNow, -60)
        
    }
    
    
    
    func testJSTDateFormatter() {
        
        guard let locale = Locale(identifier: "en_US_POSIX"), let tz = NSTimeZone(name: "JST") else {
            fatalError()
        }
        
        let formatter = DateFormatter(locale: locale)
        formatter.timeZone = tz
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        do {
            let nsDate = NSDate()
            let date = Date(nsDate)
            
            let formatted1 = formatter.string(from: date)
            let formatted2 = formatter.string(from: nsDate)
            
            XCTAssertEqual(formatted1, formatted2)
        }
        
        do {
            let dateStr = "2002-03-04 05:06:07"
            let date: Date = formatter.date(from: dateStr)!
            XCTAssertEqual(date.timeIntervalSince1970, Double(1015185967))
            XCTAssertEqual(dateStr, formatter.string(from: date))
        }
        
        do {
            let date = Date(since1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            let str = formatter.string(from: date)
            XCTAssertEqual(str, "2016-03-16 17:33:12")
        }
        
    }
    
    func testUTCDateFormatter() {
        
        guard let locale = Locale(identifier: "en_US_POSIX"), let tz = NSTimeZone(name: "UTC") else {
            fatalError()
        }
        
        let formatter = DateFormatter(locale: locale)
        formatter.timeZone = tz
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        do {
            let dateStr = "2002-03-03 20:06:07"
            let date: Date = formatter.date(from: dateStr)!
            XCTAssertEqual(date.timeIntervalSince1970, Double(1015185967))
            XCTAssertEqual(dateStr, formatter.string(from: date))
        }
        
        do {
            let date = Date(since1970: 1458117192) // Wed Mar 16 2016 08:33:12 Z
            let str = formatter.string(from: date)
            XCTAssertEqual(str, "2016-03-16 08:33:12")
        }
    }
    
    
    func testNSDateFormatter() {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        formatter.timeZone = NSTimeZone(name: "JST")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        XCTAssertNotNil(formatter.timeZone)
        XCTAssertNotNil(formatter.locale)
        
        let dateString = "2001-02-03 04:05:06"
        let date = formatter.date(from: dateString)!
        print(date)
        XCTAssertEqual(formatter.string(from: date), dateString)
        
        /*do {
            // will fail for now
            let date = NSDate(timeIntervalSince1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            let str = formatter.stringFromDate(date)
            XCTAssertEqual(str, "2016-03-16 17:33:12")
        }*/
    }
    
}

#if os(OSX)
#else
extension NSDateFormatter {
    func date(from string: String) -> NSDate? {
        return self.dateFromString(string)
    }
}
#endif

