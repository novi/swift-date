//
//  Extension.swift
//  Date
//
//  Created by Yusuke Ito on 3/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import CoreFoundation

public extension Date {
    var nsDate: NSDate {
        return NSDate(timeIntervalSince1970: timeintervalSince1970)
    }
    var cfDate: CFDate {
        return CFDateCreate(nil, self.absoluteTime)
    }
    var absoluteTime: CFAbsoluteTime {
        return timeintervalSince1970 - kCFAbsoluteTimeIntervalSince1970
    }
}

extension NSDate {
    
}

public extension DateFormatter {
    
    public func stringFromDate(date: NSDate) -> String {
        return stringFromDate(Date(date))
    }
    
    public func dateFromString(string: String) -> NSDate? {
        guard let date: Date = dateFromString(string) else {
            return nil
        }
        return date.nsDate
    }
}

extension CFString {
    
    var swiftString: String {
        #if os(OSX)
        return self as String
        #else
        let ptr = CFStringGetCStringPtr(self, UInt32(kCFStringEncodingUTF8))
            guard let str = String.fromCString(ptr) else {
                fatalError("CFString to String conversion failed, \(self)")
            }
            return str
        #endif
    }
    
    static func from(swiftString: String) -> CFString {
        #if os(OSX)
            return swiftString as CFString
        #else
            return swiftString.withCString { bytes in
                return CFStringCreateWithCString(nil, bytes, UInt32(kCFStringEncodingUTF8))
            }
        #endif
    }
}