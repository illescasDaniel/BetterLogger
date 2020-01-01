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
	
	init(
		name: String,
		handlers: [LoggerHandler] = [ConsoleLoggerHandler(formatter: XcodeLoggerOutputFormatter())],
		listeners: [BetterLogger.Severity: () -> Void] = [:]
	) {
		self.name = name
		self.handlers = handlers
		self.listeners = listeners
	}

	public func debug(
		_ messageOrValue: Any,
		context: [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		for handler in self.handlers {
			handler.log(.init(
				loggerName: self.name,
				value: messageOrValue, severity: .debug, context: context,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)	
			))
			self.listeners[.debug]?()
		}
	}
	
	public func verbose(
		_ messageOrValue: Any,
		context: [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		for handler in self.handlers {
			handler.log(.init(
				loggerName: self.name,
				value: messageOrValue, severity: .verbose, context: context,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)	
			))
			self.listeners[.verbose]?()
		}
	}
	
	public func info(
		_ messageOrValue: Any,
		context: [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		for handler in self.handlers {
			handler.log(.init(
				loggerName: self.name,
				value: messageOrValue, severity: .info, context: context,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)	
			))
			self.listeners[.info]?()
		}
	}
	
	public func warning(
		_ messageOrValue: Any,
		context: [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		for handler in self.handlers {
			handler.log(.init(
				loggerName: self.name,
				value: messageOrValue, severity: .warning, context: context,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)	
			))
			self.listeners[.warning]?()
		}
	}
	
	public func error(
		_ messageOrValue: Any,
		context: [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		for handler in self.handlers {
			handler.log(.init(
				loggerName: self.name,
				value: messageOrValue, severity: .error, context: context,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)	
			))
			self.listeners[.error]?()
		}
	}
	
	public func fatalError(
		_ messageOrValue: Any,
		context: [String: Any] = [:],

		_file: String = #file, _function: String = #function, _line: Int = #line, _column: Int = #column
	) {
		for handler in self.handlers {
			handler.log(.init(
				loggerName: self.name,
				value: messageOrValue, severity: .fatalError, context: context,
				metadata: .init(file: _file, function: _function, line: _line, column: _column)	
			))
			self.listeners[.fatalError]?()
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
	
	public struct Parameters {
		public let loggerName: String
		public let value: Any
		public let severity: BetterLogger.Severity
		public let context: [String: Any]
		public let metadata: BetterLogger.Metadata
	}
}

// Internal convenience functions

internal extension String {
	var lastPathComponent: String {
		return URL(fileURLWithPath: self).lastPathComponent
	}
}

internal func _stringRepresentationFrom(_ value: Any) -> String {
	let objectMirror = Mirror(reflecting: value)
	var objectDescription = ""
	if value is CustomStringConvertible || value is CustomDebugStringConvertible || objectMirror.displayStyle == .enum || objectMirror.displayStyle == .struct {
		objectDescription = String(describing: value)
	} else {
		dump(value, to: &objectDescription)
	}
	return objectDescription
}
