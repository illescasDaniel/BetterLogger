//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public struct ConsoleLoggerHandler: LoggerHandler {
	
	public let formatter: LoggerOutputFormatter
	
	public init(formatter: LoggerOutputFormatter) {
		self.formatter = formatter
	}
	
	public func log(_ parameters: BetterLogger.Parameters) {
		print(
			formatter.stringRepresentationFrom(parameters)
		)
	}
}
