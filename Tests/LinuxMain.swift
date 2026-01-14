import XCTest

import BetterLoggerTests

var tests = [XCTestCaseEntry]()
tests += BetterLoggerTests.allTests()
tests += BetterLoggerUnitTests.allTests()
XCTMain(tests)
