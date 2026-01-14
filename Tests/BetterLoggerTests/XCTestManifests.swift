import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(BetterLoggerTests.allTests),
		testCase(BetterLoggerUnitTests.allTests),
	]
}
#endif
