//
//  LoggerOutputFormatter.swift
//  
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public protocol LoggerOutputFormatter: Sendable {
	func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String
}
