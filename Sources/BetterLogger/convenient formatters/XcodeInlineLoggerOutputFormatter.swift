//
//  XcodeInlineLoggerOutputFormatter.swift
//
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation

public struct XcodeInlineLoggerOutputFormatter: LoggerOutputFormatter {

	public init() {}

	public func stringRepresentationFrom(_ parameters: BetterLogger.Parameters) -> String {

		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

		let aContext = parameters.context.isEmpty ? "" : "  \n- Context: \(_stringRepresentationFromDictionary(parameters.context))"

		let objectDescription = _stringRepresentationFrom(parameters.value)

		return "\(dateFormatter.string(from: date)) | \(parameters.severity) | \(parameters.metadata.file.lastPathComponent):\(parameters.metadata.line):\(parameters.metadata.column) \(parameters.metadata.function.trimmingCharacters(in: .whitespacesAndNewlines)) | Message: \(objectDescription)\(aContext)"
	}
}
