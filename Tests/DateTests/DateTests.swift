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

extension DateAllTests {
    static var allTests : [(String, (DateAllTests) -> () throws -> Void)] {
        return [
                   //("testDate", testDate),
                   ("testJSTDateFormatter", testJSTDateFormatter),
                   ("testUTCDateFormatter", testUTCDateFormatter),
                   ("testNSDateFormatter", testNSDateFormatter)
        ]
    }
}

#if !os(macOS)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase( DateAllTests.allTests ),
        ]
    }
#endif


class DateAllTests: XCTestCase {
    
    #if os(macOS)
    func testDate() {
        do {
            let now1 = Date()
            let nsdate = now1.nsDate
            let now2 = nsdate as Date
            
            //XCTAssertEqual(now1, now2)
            XCTAssertEqual(now1.description, now2.description)
            XCTAssertEqual(nsdate.timeIntervalSince1970, now2.timeIntervalSince1970)
            
            let abs1 = now2.timeIntervalSinceReferenceDate
            XCTAssertTrue(CFEqual(CFDateCreate(nil, abs1), now2.cfDate))
            let now3 = Date(timeIntervalSinceReferenceDate: abs1)
            
            XCTAssertEqual(now2, now3)
            // XCTAssertEqual(now1, now3)
            XCTAssertEqual(now1.description, now3.description)
        }
    }
    #endif
    
    
    
    func testJSTDateFormatter() {
        
        guard let locale = LocaleCF(identifier: "en_US_POSIX"), let tz = TimeZone(abbreviation: "JST") else {
            fatalError()
        }
        
        let formatter = DateFormatterCF(locale: locale)
        formatter.timeZone = tz
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        do {
            let dateStr = "2002-03-04 05:06:07"
            let date: Date = formatter.date(from: dateStr)!
            XCTAssertEqual(date.timeIntervalSince1970, Double(1015185967))
            XCTAssertEqual(dateStr, formatter.string(from: date))
        }
        
        do {
            let date = Date(timeIntervalSince1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            let str = formatter.string(from: date)
            XCTAssertEqual(str, "2016-03-16 17:33:12")
        }
        
    }
    
    func testUTCDateFormatter() {
        
        guard let locale = LocaleCF(identifier: "en_US_POSIX"), let tz = TimeZone(abbreviation: "UTC") else {
            fatalError()
        }
        
        let formatter = DateFormatterCF(locale: locale)
        formatter.timeZone = tz
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        do {
            let dateStr = "2002-03-03 20:06:07"
            let date: Date = formatter.date(from: dateStr)!
            XCTAssertEqual(date.timeIntervalSince1970, Double(1015185967))
            XCTAssertEqual(dateStr, formatter.string(from: date))
        }
        
        do {
            let date = Date(timeIntervalSince1970: 1458117192) // Wed Mar 16 2016 08:33:12 Z
            let str = formatter.string(from: date)
            XCTAssertEqual(str, "2016-03-16 08:33:12")
        }
    }
    
    func testNSDateFormatter() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        
        formatter.timeZone = TimeZone(abbreviation: "JST")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        XCTAssertNotNil(formatter.timeZone)
        XCTAssertNotNil(formatter.locale)
        
        let dateString = "2001-02-03 04:05:06"
        let date = formatter.date(from: dateString)!
        print(date)
        XCTAssertEqual(formatter.string(from: date), dateString)
        
        do {
            // will fail for now
            // 2016/08/09; it seems to be fixed.
            let date = Date(timeIntervalSince1970: 1458117192) // Wed Mar 16 2016 17:33:12 GMT+0900 (JST)
            let str = formatter.string(from: date)
            XCTAssertEqual(str, "2016-03-16 17:33:12")
        }
    }
    
}

