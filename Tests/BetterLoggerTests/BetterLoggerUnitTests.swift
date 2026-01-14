import XCTest
import BetterLogger

final class BetterLoggerUnitTests: XCTestCase {

	func testInitialization() {
		let logger = BetterLogger(name: "TestLogger")
		XCTAssertEqual(logger.name, "TestLogger")
		XCTAssertEqual(logger.minimumSeverity, .debug)
		XCTAssertFalse(logger.handlers.isEmpty)
	}

	func testSeverityFiltering() {
		let mockHandler = MockLoggerHandler()
		let logger = BetterLogger(name: "TestLogger", handlers: [mockHandler])
		logger.minimumSeverity = .info

		// This should be ignored
		logger.debug("Debug message")
		XCTAssertTrue(mockHandler.capturedParameters.isEmpty)

		// This should be captured
		logger.info("Info message")
		XCTAssertEqual(mockHandler.capturedParameters.count, 1)
		XCTAssertEqual(mockHandler.capturedParameters.first?.severity, .info)
		XCTAssertEqual(mockHandler.capturedParameters.first?.value as? String, "Info message")
	}

	func testHandlerDelegation() {
		let mockHandler = MockLoggerHandler()
		let logger = BetterLogger(name: "TestLogger", handlers: [mockHandler])

		let context = ["key": "value"]
		logger.warning("Warning message", context: context)
		
		XCTAssertEqual(mockHandler.capturedParameters.count, 1)
		let params = mockHandler.capturedParameters.first!

		XCTAssertEqual(params.loggerName, "TestLogger")
		XCTAssertEqual(params.value as? String, "Warning message")
		XCTAssertEqual(params.severity, .warning)
		XCTAssertEqual(params.context["key"] as? String, "value")

		// Check metadata existence (exact values depend on line numbers)
		XCTAssertFalse(params.metadata.file.isEmpty)
		XCTAssertFalse(params.metadata.function.isEmpty)
		XCTAssertGreaterThan(params.metadata.line, 0)
	}

	func testListeners() {
		let expectation = self.expectation(description: "Listener called")
		let localLogger = BetterLogger(name: "ListenerLogger", handlers: [], listeners: [
			.error: {
				expectation.fulfill()
			}
		])

		localLogger.info("This should not trigger listener")
		localLogger.error("This SHOULD trigger listener")

		waitForExpectations(timeout: 1.0, handler: nil)
	}
}
