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
        return CFDateCreate(nil, self.timeIntervalSinceReferenceDate)
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

