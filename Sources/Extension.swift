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

extension NSDateFormatter {
    
    public func stringFromDate(date: Date) -> String {
        return stringFromDate(date.nsDate)
    }
    
    public func dateFromString(string: String) -> Date? {
        guard let nsDate = self.dateFromString(string) as NSDate? else {
            return nil
        }
        return Date(nsDate)
    }
}