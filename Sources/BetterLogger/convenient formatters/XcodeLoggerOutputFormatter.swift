//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public struct XcodeLoggerOutputFormatter: LoggerOutputFormatter {
	
	public init() {}
	
	public func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String {
		
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en")
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short

		let aContext = parameters.context.isEmpty ? "" : "\n\n- Context: \n\(_stringRepresentationFrom(parameters.context))"

		let objectDescription = _stringRepresentationFrom(parameters.value)

		return """
		======================================================
		  (\(parameters.loggerName) logger)
		  === \(parameters.severity.icon) [\(parameters.severity)] \(parameters.severity.icon) - [\(dateFormatter.string(from: date))]  ===
		  ===  \(parameters.metadata.file.lastPathComponent):\(parameters.metadata.line):\(parameters.metadata.column) \(parameters.metadata.function)  ===
			
		\(objectDescription)\(aContext)
		
		======================================================
		"""
	}
}
