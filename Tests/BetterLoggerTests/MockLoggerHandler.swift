import Foundation
import BetterLogger

class MockLoggerHandler: LoggerHandler {

	struct MockFormatter: LoggerOutputFormatter {
		func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String {
			return ""
		}
	}

	var capturedParameters: [BetterLogger.Parameters] = []
	var formatter: LoggerOutputFormatter = MockFormatter()

	func log(_ parameters: BetterLogger.Parameters) {
		capturedParameters.append(parameters)
	}

	func reset() {
		capturedParameters.removeAll()
	}
}
