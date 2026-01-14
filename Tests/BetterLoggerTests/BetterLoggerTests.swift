import XCTest
import BetterLogger

struct Person {
	let name: String
}

final class BetterLoggerTests: XCTestCase {

	var log: BetterLogger { BetterLogger.default }

	func testSeverities() {
		log.debug("Debug stuff")
		log.verbose("Verbose stuff")
		log.info("Some info here")
		log.warning("This is a warning", context: ["person": Person(name: "Daniel")])
		log.error("Death note")
		log.fatalError("Death note")
	}

	func testMinimumSeverity() {
		let customLogger = BetterLogger(
			name: "Custom logger 0",
			handlers: [ConsoleLoggerHandler(formatter: ColoredConsoleLoggerOutputFormatter())],
			listeners: [:]
		)
		customLogger.minimumSeverity = .warning
		customLogger.debug("THIS SHOULDN'T PRINT")
		customLogger.verbose("THIS SHOULDN'T PRINT")
		customLogger.info("THIS SHOULDN'T PRINT")
		customLogger.warning("THIS SHOULD PRINT", context: ["person": Person(name: "Daniel")])
		customLogger.error("THIS SHOULD PRINT")
		customLogger.fatalError("THIS SHOULD PRINT")
	}

	func testCustomLoggerSeverities() {
		let customLogger = BetterLogger(
			name: "Custom logger 1",
			handlers: [ConsoleLoggerHandler(formatter: ColoredConsoleLoggerOutputFormatter())],
			listeners: [:]
		)
		customLogger.debug("Debug stuff")
		customLogger.verbose("Verbose stuff")
		customLogger.info("Some info here", context: ["some key": [1,2,3]])
		customLogger.warning("This is a warning", context: ["person": Person(name: "Daniel")])
		customLogger.error("Death note")
		customLogger.fatalError("Death note")
	}

	func testXcodeInlineLoggerSeverities() {
		let customLogger = BetterLogger(
			name: "Custom logger 1",
			handlers: [ConsoleLoggerHandler(formatter: XcodeInlineLoggerOutputFormatter())],
			listeners: [:]
		)
		customLogger.debug("Debug stuff")
		customLogger.verbose("Verbose stuff")
		customLogger.info("Some info here", context: ["some key": [1,2,3]])
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
		("testMinimumSeverity", testMinimumSeverity),
		("testCustomLoggerSeverities", testCustomLoggerSeverities),
		("testCustomLoggerListeners", testCustomLoggerListeners),
	]
}
