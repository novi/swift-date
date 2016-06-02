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
        return NSDate(timeIntervalSince1970: timeIntervalSince1970)
    }
    var cfDate: CFDate {
        return CFDateCreate(nil, self.absoluteTime)
    }
    var absoluteTime: CFAbsoluteTime {
        return timeIntervalSince1970 - kCFAbsoluteTimeIntervalSince1970
    }
}

extension NSDateFormatter {
    
}

public extension DateFormatter {
    
    public func string(from date: NSDate) -> String {
        return string(from: Date(date))
    }
    
    public func date(from string: String) -> NSDate? {
        guard let date: Date = date(from: string) else {
            return nil
        }
        return date.nsDate
    }
}

extension CFString {
    
    func bridge() -> String {
        #if os(OSX)
            return self as String
        #else
            let str = unsafeBitCast(self, to: NSString.self)
            return str.bridge()
        #endif
    }
}

extension String {
    func bridge() -> CFString {
        #if os(OSX)
            return self as CFString
        #else
            let str: NSString = self.bridge()
            return unsafeBitCast(str, to: CFString.self)
        #endif
    }
}

