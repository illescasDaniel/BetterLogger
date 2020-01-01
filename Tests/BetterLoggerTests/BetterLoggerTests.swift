import XCTest
@testable import BetterLogger

struct Person {
    let name: String
}

final class BetterLoggerTests: XCTestCase {
	
	var log: BetterLogger { BetterLogger.default }
	
    func testSeverities() {
		log.info("Some info here")
		log.warning("This is a warning", context: ["person": Person(name: "Daniel")])
		log.error("Death note")
		log.fatalError("Death note")
    }
	
	func testCustomLoggerSeverities() {
		let customLogger = BetterLogger(
			name: "Custom logger 1",
			handlers: [ConsoleLoggerHandler(formatter: ColoredConsoleLoggerOutputFormatter())],
			listeners: [:]
		)
		customLogger.info("Some info here")
		customLogger.warning("This is a warning", context: ["person": Person(name: "Daniel")])
		customLogger.error("Death note")
		customLogger.fatalError("Death note")
    }
	
	func testCustomLoggerListeners() {
		let exp = expectation(description: "Listeners")
		exp.expectedFulfillmentCount = 3
		exp.assertForOverFulfill = true
		
		let customLogger = BetterLogger(
			name: "Custom logger 2",
			handlers: [ConsoleLoggerHandler(formatter: XcodeLoggerOutputFormatter())],
			listeners: [
				.info: {
					print("info")
					exp.fulfill()
				},
				.fatalError: {
					print("exiting app...")
					exp.fulfill()
				}
			]
		)
		customLogger.info("Some info here")
		customLogger.info("Some info here 2")
		customLogger.warning("This is a warning", context: ["person": Person(name: "Daniel")])
		customLogger.error("Death note")
		customLogger.fatalError("Death note")
		
		waitForExpectations(timeout: 3)
    }

    static var allTests = [
        ("testSeverities", testSeverities),
		("testCustomLoggerSeverities", testCustomLoggerSeverities),
		("testCustomLoggerListeners", testCustomLoggerListeners),
    ]
}
