//
//  utils.swift
//  BetterLogger
//
//  Created by Daniel Illescas Romero on 14/1/26.
//

import Foundation

internal extension String {
	var lastPathComponent: String {
		return URL(fileURLWithPath: self).lastPathComponent
	}
}

internal extension Dictionary where Key == String {
	func smartDescription() -> String {
		// 1. Try to format as JSON first
		if JSONSerialization.isValidJSONObject(self),
			let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
			let jsonString = String(data: data, encoding: .utf8) {
			return jsonString
		}

		// 2. Fallback: Capture the output of dump() into a string
		var dumpOutput = ""
		dump(self, to: &dumpOutput)
		return dumpOutput
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

internal func _stringRepresentationFromDictionary(_ value: [String: Any]) -> String {
	value.smartDescription()
}
