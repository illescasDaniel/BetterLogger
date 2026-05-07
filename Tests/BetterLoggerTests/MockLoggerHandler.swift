import Foundation
import BetterLogger

final class MockLoggerHandler: LoggerHandler, @unchecked Sendable {

	struct MockFormatter: LoggerOutputFormatter, Sendable {
		func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String {
			return ""
		}
	}

	private let lock = NSLock()
	private var _capturedParameters: [BetterLogger.Parameters] = []
	var capturedParameters: [BetterLogger.Parameters] {
		lock.lock()
		defer { lock.unlock() }
		return _capturedParameters
	}
	
	var formatter: LoggerOutputFormatter = MockFormatter()

	func log(_ parameters: BetterLogger.Parameters) {
		lock.lock()
		defer { lock.unlock() }
		_capturedParameters.append(parameters)
	}

	func reset() {
		lock.lock()
		defer { lock.unlock() }
		_capturedParameters.removeAll()
	}
}
