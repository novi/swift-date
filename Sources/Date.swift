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
    
    public let timeintervalSince1970: NSTimeInterval // unix time
    
    public init(since1970: NSTimeInterval) {
        self.timeintervalSince1970 = since1970
    }
    public init(sinceReference: NSTimeInterval) {
        self.timeintervalSince1970 = sinceReference + kCFAbsoluteTimeIntervalSince1970
    }
    //static let CFAbsoluteTimeIntervalSince1970: Double = 978307200;
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
        return timeintervalSince1970.hashValue
    }
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeintervalSince1970 == rhs.timeintervalSince1970
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeintervalSince1970 < rhs.timeintervalSince1970
}

public func <=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeintervalSince1970 <= rhs.timeintervalSince1970
}

public func >=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeintervalSince1970 >= rhs.timeintervalSince1970
}

public func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeintervalSince1970 > rhs.timeintervalSince1970
}

public func -(lhs: Date, rhs: Date) -> NSTimeInterval {
    return lhs.timeintervalSince1970 - rhs.timeintervalSince1970
}

public func +(lhs: Date, rhs: Date) -> NSTimeInterval {
    return lhs.timeintervalSince1970 + rhs.timeintervalSince1970
}

