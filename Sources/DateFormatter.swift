//
//  DateFormatter.swift
//  Date
//
//  Created by Yusuke Ito on 3/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import CoreFoundation
import Foundation

public final class LocaleCF {
    public let locale: CFLocale
    public init?(identifier: String) {
        #if os(macOS)
        guard let locale = CFLocaleCreate(nil, CFLocaleIdentifier(rawValue: identifier.bridge())) else {
            return nil
        }
        self.locale = locale
        #else
        guard let locale = CFLocaleCreate(nil, identifier.bridge()) else {
            return nil
        }
        self.locale = locale
        #endif
    }
}

#if os(Linux)
    
    // https://github.com/apple/swift-corelibs-foundation/blob/master/CoreFoundation/Locale.subproj/CFDateFormatter.h#L36
    public enum CFDateFormatterStyle : Int {
        
        case noStyle = 0
        case shortStyle = 1
        case mediumStyle = 2
        case longStyle = 3
        case fullStyle = 4
    }
#endif


public final class DateFormatterCF {
    public let formatter: CFDateFormatter
    public init(locale: LocaleCF, dateStyle: CFDateFormatterStyle = .noStyle, timeStyle: CFDateFormatterStyle = .noStyle) {
        #if os(macOS)
            formatter = CFDateFormatterCreate(nil, locale.locale, dateStyle, timeStyle)
            self.timeZone = TimeZone(secondsFromGMT: 0)!
        #else
            formatter = CFDateFormatterCreate(nil, locale.locale, dateStyle.rawValue, timeStyle.rawValue)
            self.timeZone = TimeZone(abbreviation: "UTC")!
        #endif
        
    }
    public var dateFormat: String? {
        didSet {
            if let val = dateFormat {
                CFDateFormatterSetFormat(formatter, val.bridge())
            }
        }
    }
    public var timeZone: TimeZone {
        didSet {
            #if os(macOS)
            CFDateFormatterSetProperty(formatter, CFDateFormatterKey.timeZone.rawValue, timeZone as NSTimeZone)
            #else
            CFDateFormatterSetProperty(formatter, kCFDateFormatterTimeZone, unsafeBitCast(timeZone._bridgeToObjectiveC(), to: CFTimeZone.self))
            #endif
        }
    }
}

public extension DateFormatterCF {
    
    func string(from date: Date) -> String {
        return CFDateFormatterCreateStringWithAbsoluteTime(nil, formatter, date.timeIntervalSinceReferenceDate).bridge()
    }
    
    func date(from string: String) -> Date? {
        var out: CFAbsoluteTime = 0
        if CFDateFormatterGetAbsoluteTimeFromString(formatter, string.bridge(), nil, &out) {
            return Date(timeIntervalSinceReferenceDate: out)
        }
        return nil
    }
}

