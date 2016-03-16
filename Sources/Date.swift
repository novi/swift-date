//
//  Date.swift
//  Date
//
//  Created by Yusuke Ito on 3/16/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import CoreFoundation

public struct Date: Equatable, Hashable, Comparable {
    
    public let timeIntervalSince1970: NSTimeInterval // unix time
    
    public init(since1970: NSTimeInterval) {
        self.timeIntervalSince1970 = since1970
    }
    public init(sinceReference: NSTimeInterval) {
        self.timeIntervalSince1970 = sinceReference + kCFAbsoluteTimeIntervalSince1970
    }
}

extension Date: CustomStringConvertible {
    public var description: String {
        return "\(nsDate.description)"
    }
}

extension Date {
    public init(absoluteTime: CFAbsoluteTime) {
        self.init(sinceReference: absoluteTime)
    }
    public init() {
        self.init(absoluteTime: CFAbsoluteTimeGetCurrent())
    }
    public init(_ date: NSDate) {
        self.init(since1970: date.timeIntervalSince1970)
    }
    public init(_ cfDate: CFDate) {
        self.init(absoluteTime: CFDateGetAbsoluteTime(cfDate))
    }
}

extension Date {
    public var hashValue: Int {
        return timeIntervalSince1970.hashValue
    }
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}

public func <=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}

public func >=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}

public func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}

public func -(lhs: Date, rhs: Date) -> NSTimeInterval {
    return lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970
}

public func +(lhs: Date, rhs: Date) -> NSTimeInterval {
    return lhs.timeIntervalSince1970 + rhs.timeIntervalSince1970
}

public func +(lhs: Date, rhs: NSTimeInterval) -> Date {
    return Date(since1970: lhs.timeIntervalSince1970 + rhs)
}

public func -(lhs: Date, rhs: NSTimeInterval) -> Date {
    return Date(since1970: lhs.timeIntervalSince1970 - rhs)
}

