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

#if os(OSX)
    protocol XCTestCaseProvider {
        var allTests: [(String, () throws -> Void)] { get }
    }
    
#endif

extension DateTests {
    static var allTests : [(String, DateTests -> () throws -> Void)] {
        return [
                   ("testDate", testDate),
                   ("testJSTDateFormatter", testJSTDateFormatter),
                   ("testUTCDateFormatter", testUTCDateFormatter)
        ]
    }
}

class DateTests: XCTestCase, XCTestCaseProvider {
    
    var allTests: [(String, () throws -> Void)] {
        return self.dynamicType.allTests.map{ ($0.0, $0.1(self)) }
    }
    
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
        
        do {
            let date = Date(since1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            XCTAssertEqual(date.timeintervalSince1970, 1458117192)
        }
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
        
        do {
            let date = Date(since1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            let str = formatter.stringFromDate(date)
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
            let date: Date = formatter.dateFromString(dateStr)!
            XCTAssertEqual(date.timeintervalSince1970, Double(1015185967))
            XCTAssertEqual(dateStr, formatter.stringFromDate(date))
        }
        
        do {
            let date = Date(since1970: 1458117192) // Wed Mar 16 2016 08:33:12 Z
            let str = formatter.stringFromDate(date)
            XCTAssertEqual(str, "2016-03-16 08:33:12")
        }
    }
    
    
    
}
