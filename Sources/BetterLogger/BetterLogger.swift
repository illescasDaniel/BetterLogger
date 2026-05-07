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

public struct BetterLogger: Sendable {

	public static let `default` = BetterLogger(name: "Default")

	private let storage: Storage

	public var name: String { storage.name }
	public var handlers: [LoggerHandler] {
		get { storage.handlers }
		nonmutating set { storage.handlers = newValue }
	}
	public var listeners: [BetterLogger.Severity: @Sendable () -> Void] {
		get { storage.listeners }
		nonmutating set { storage.listeners = newValue }
	}
	public var minimumSeverity: Severity {
		get { storage.minimumSeverity }
		nonmutating set { storage.minimumSeverity = newValue }
	}

	public init(
		name: String,
		handlers: [LoggerHandler] = [PrintLoggerHandler(formatter: XcodeLoggerOutputFormatter())],
		listeners: [BetterLogger.Severity: @Sendable () -> Void] = [:]
	) {
		self.storage = Storage(name: name, handlers: handlers, listeners: listeners)
	}

	public func debug(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .debug,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func verbose(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .verbose,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func info(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .info,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func warning(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .warning,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func error(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .error,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	public func fatalError(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		log(
			messageOrValue(), context: context(), severity: .fatalError,
			_file: _file, _function: _function, _line: _line, _column: _column
		)
	}

	//

	private func log(
		_ messageOrValue: @autoclosure () -> any Sendable,
		context: @autoclosure () -> [String: any Sendable] = [:],
		contextPrivacy: ContextPrivacy = .public,
		severity: Severity,

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		self.storage.log(
			messageOrValue: messageOrValue(),
			context: context(),
			contextPrivacy: contextPrivacy,
			severity: severity,
			_file: _file,
			_function: _function,
			_line: _line,
			_column: _column
		)
	}

	private final class Storage: @unchecked Sendable {
		let name: String
		private let lock = NSRecursiveLock()
		private var _handlers: [LoggerHandler]
		private var _listeners: [BetterLogger.Severity: @Sendable () -> Void]
		private var _minimumSeverity: BetterLogger.Severity = .debug

		init(name: String, handlers: [LoggerHandler], listeners: [BetterLogger.Severity: @Sendable () -> Void]) {
			self.name = name
			self._handlers = handlers
			self._listeners = listeners
		}

		var handlers: [LoggerHandler] {
			get { lock.withLock { _handlers } }
			set { lock.withLock { _handlers = newValue } }
		}

		var listeners: [BetterLogger.Severity: @Sendable () -> Void] {
			get { lock.withLock { _listeners } }
			set { lock.withLock { _listeners = newValue } }
		}

		var minimumSeverity: BetterLogger.Severity {
			get { lock.withLock { _minimumSeverity } }
			set { lock.withLock { _minimumSeverity = newValue } }
		}

		func log(
			messageOrValue: any Sendable,
			context: [String: any Sendable],
			contextPrivacy: BetterLogger.ContextPrivacy,
			severity: BetterLogger.Severity,
			_file: String, _function: String, _line: Int, _column: Int
		) {
			lock.lock()
			let minSeverity = _minimumSeverity
			let handlers = _handlers
			let listener = _listeners[severity]
			lock.unlock()

			guard severity >= minSeverity else {
				return
			}
			listener?()
			let parameters = Parameters(
				loggerName: self.name,
				value: messageOrValue,
				severity: severity,
				context: context,
				contextPrivacy: contextPrivacy,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)
			)
			for handler in handlers {
				handler.log(parameters)
			}
		}
	}
}

private extension NSRecursiveLock {
	func withLock<T>(_ body: () -> T) -> T {
		self.lock()
		defer { self.unlock() }
		return body()
	}
}

extension BetterLogger {

	public struct Metadata: Sendable {
		public let file: String
		public let function: String
		public let line: Int
		public let column: Int
	}

	public enum Severity: Int, Sendable {
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

	public enum ContextPrivacy: Sendable {
		case `public`
		case `private`
	}

	public struct Parameters: Sendable {
		public let loggerName: String
		public let value: any Sendable
		public let severity: BetterLogger.Severity
		public let context: [String: any Sendable]
		public let contextPrivacy: ContextPrivacy
		public let metadata: BetterLogger.Metadata
	}
}
extension BetterLogger.Severity: Comparable {
	public static func <(lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}
