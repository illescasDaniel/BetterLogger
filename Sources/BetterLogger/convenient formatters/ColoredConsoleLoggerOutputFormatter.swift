//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public struct ColoredConsoleLoggerOutputFormatter: LoggerOutputFormatter {
	
	public init() {}
	
	public func colored(string: String, severity: BetterLogger.Severity) -> String {
		let escape = "\u{001b}["
		let reset = "\u{001b}[0m"
		func colorStr(_ color: String) -> String {
			return escape + color + string + reset
		}
		switch severity {
		case .debug: return colorStr("35m")
		case .verbose: return colorStr("0m")
		case .info: return colorStr("36m")
		case .warning: return colorStr("33m")
		case .error: return colorStr("31m")
		case .fatalError: return colorStr("31m")
		}
	}
	
	public func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String {
		
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short

		let aContext = parameters.context.isEmpty ? "" : "\n\n- Context: \n\(_stringRepresentationFrom(parameters.context))"

		let objectDescription = _stringRepresentationFrom(parameters.value)

		let p1 = """
		======================================================
		  (\(parameters.loggerName) logger)
		  === \(parameters.severity.icon) [\(parameters.severity)] \(parameters.severity.icon) - [\(dateFormatter.string(from: date))]  ===
		  ===  \(parameters.metadata.file.lastPathComponent):\(parameters.metadata.line):\(parameters.metadata.column) \(parameters.metadata.function)  ===
		
		"""
		let p2 = "\n\(objectDescription)\(aContext)\n"
		let p3 = "======================================================"
		return colored(string: p1, severity: parameters.severity) + p2 + colored(string: p3, severity: parameters.severity)
	}
}
