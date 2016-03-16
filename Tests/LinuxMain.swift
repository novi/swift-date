import XCTest

#if os(Linux)
    import Glibc
    @testable import Datetest
    
    XCTMain([
                DateTests()
             ])
#else
    @testable import DateTestSuite
    
XCTMain([
            testCase(DateTests.allTests)
    ])
#endif