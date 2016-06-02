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
        guard let locale = CFLocaleCreate(nil, identifier.bridge()) else {
            return nil
        }
        self.locale = locale
    }
}

#if os(OSX)
#else
    // https://github.com/apple/swift-corelibs-foundation/blob/master/CoreFoundation/Locale.subproj/CFDateFormatter.h#L36
    public enum CFDateFormatterStyle : Int {
        
        case noStyle = 0
        case shortStyle = 1
        case mediumStyle = 2
        case longStyle = 3
        case fullStyle = 4
    }
#endif


public final class DateFormatter {
    public let formatter: CFDateFormatter
    public init(locale: Locale, dateStyle: CFDateFormatterStyle = .noStyle, timeStyle: CFDateFormatterStyle = .noStyle) {
        #if os(OSX)
            formatter = CFDateFormatterCreate(nil, locale.locale, dateStyle, timeStyle)
            timeZone = NSTimeZone.default()
        #else
            formatter = CFDateFormatterCreate(nil, locale.locale, dateStyle.rawValue, timeStyle.rawValue)
            timeZone = NSTimeZone.defaultTimeZone()
        #endif
    }
    public var dateFormat: String? {
        didSet {
            if let val = dateFormat {
                CFDateFormatterSetFormat(formatter, val.bridge())
            }
        }
    }
    public var timeZone: NSTimeZone {
        didSet {
            CFDateFormatterSetProperty(formatter, kCFDateFormatterTimeZone, timeZone)
        }
    }
}

public extension DateFormatter {
    
    func string(from date: Date) -> String {
        return CFDateFormatterCreateStringWithAbsoluteTime(nil, formatter, date.absoluteTime).bridge()
    }
    
    func date(from string: String) -> Date? {
        var out: CFAbsoluteTime = 0
        if CFDateFormatterGetAbsoluteTimeFromString(formatter, string.bridge(), nil, &out) {
            return Date(absoluteTime: out)
        }
        return nil
    }
}

