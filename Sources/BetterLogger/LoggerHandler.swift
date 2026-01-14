//
//  LoggerHandler.swift
//  
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public protocol LoggerHandler {
	var formatter: LoggerOutputFormatter { get }
	func log(_ parameters: BetterLogger.Parameters)
}
