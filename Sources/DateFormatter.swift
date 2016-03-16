//
//  DateFormatter.swift
//  Date
//
//  Created by Yusuke Ito on 3/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import CoreFoundation

public final class Locale {
    public let locale: CFLocale
    public init?(identifier: String) {
        let locale = CFLocaleCreate(nil, CFString.from(identifier))
        if locale == nil {
            return nil
        }
        self.locale = locale
    }
}

#if os(OSX)
#else
    // https://github.com/apple/swift-corelibs-foundation/blob/master/CoreFoundation/Locale.subproj/CFDateFormatter.h#L36
    public enum CFDateFormatterStyle : Int {
        
        case NoStyle = 0
        case ShortStyle = 1
        case MediumStyle = 2
        case LongStyle = 3
        case FullStyle = 4
    }
#endif


public final class DateFormatter {
    public let formatter: CFDateFormatter
    public init(locale: Locale, dateStyle: CFDateFormatterStyle = .NoStyle, timeStyle: CFDateFormatterStyle = .NoStyle) {
        #if os(OSX)
            formatter = CFDateFormatterCreate(nil, locale.locale, dateStyle, timeStyle)
        #else
        formatter = CFDateFormatterCreate(nil, locale.locale, dateStyle.rawValue, timeStyle.rawValue)
        #endif
    }
    var dateFormat: String? {
        didSet {
            if let val = dateFormat {
                CFDateFormatterSetFormat(formatter, CFString.from(val))
            }
        }
    }
    var timeZone: NSTimeZone = NSTimeZone.systemTimeZone() {
        didSet {
            CFDateFormatterSetProperty(formatter, kCFDateFormatterTimeZone, timeZone)
        }
    }
}

public extension DateFormatter {
    
    func stringFromDate(date: Date) -> String {
        return CFDateFormatterCreateStringWithAbsoluteTime(nil, formatter, date.absoluteTime).swiftString
    }
    
    func dateFromString(string: String) -> Date? {
        var out: CFAbsoluteTime = 0
        if CFDateFormatterGetAbsoluteTimeFromString(formatter, CFString.from(string), nil, &out) {
            return Date(absoluteTime: out)
        }
        return nil
    }
}

