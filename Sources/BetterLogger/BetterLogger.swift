/*
The MIT License (MIT)

Copyright (c) 2019 Daniel Illescas Romero
https://github.com/illescasDaniel/BetterLogger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

public class BetterLogger {

	public static let `default` = BetterLogger(name: "Default")

	public let name: String
	public var handlers: [LoggerHandler]
	public var listeners: [BetterLogger.Severity: () -> Void]
	public var minimumSeverity: Severity = .debug

	public init(
		name: String,
		handlers: [LoggerHandler] = [PrintLoggerHandler(formatter: XcodeLoggerOutputFormatter())],
		listeners: [BetterLogger.Severity: () -> Void] = [:]
	) {
		self.name = name
		self.handlers = handlers
		self.listeners = listeners
	}

	public func debug(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .debug,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func verbose(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .verbose,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func info(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .info,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func warning(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .warning,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func error(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .error,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func fatalError(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .fatalError,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	//

	private func log(
		_ messageOrValue: @autoclosure () -> Any,
		context: @autoclosure () -> [String: Any] = [:],
		contextPrivacy: ContextPrivacy = .public,
		severity: Severity,

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		guard severity >= minimumSeverity else {
			return
		}
		self.listeners[severity]?()
		for handler in self.handlers {
			handler.log(Parameters(
				loggerName: self.name,
				value: messageOrValue(),
				severity: severity,
				context: context(),
				contextPrivacy: contextPrivacy,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)
			))
		}
	}
}
extension BetterLogger {

	public struct Metadata {
		public let file: String
		public let function: String
		public let line: Int
		public let column: Int
	}

	public enum Severity: Int {
		case debug
		case verbose
		case info
		case warning
		case error
		case fatalError

		public var icon: String {
			switch self {
			case .debug: return "🐞"
			case .verbose: return "📄"
			case .info: return "ℹ️"
			case .warning: return "⚠️"
			case .error: return "❌"
			case .fatalError: return "💥"
			}
		}
	}

	public enum ContextPrivacy {
		case `public`
		case `private`
	}

	public struct Parameters {
		public let loggerName: String
		public let value: Any
		public let severity: BetterLogger.Severity
		public let context: [String: Any]
		public let contextPrivacy: ContextPrivacy
		public let metadata: BetterLogger.Metadata
	}
}
extension BetterLogger.Severity: Comparable {
	public static func <(lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}
