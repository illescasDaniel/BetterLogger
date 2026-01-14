//
//  SimpleLoggerOutputFormatter.swift
//  
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public struct SimpleLoggerOutputFormatter: LoggerOutputFormatter {
	
	public init() {}
	
	public func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String {
		let aContext = parameters.context.isEmpty ? "" : "\n\n- Context: \n\(_stringRepresentationFromDictionary(parameters.context))"
		return "\(parameters.value)\(aContext)"
	}
}
