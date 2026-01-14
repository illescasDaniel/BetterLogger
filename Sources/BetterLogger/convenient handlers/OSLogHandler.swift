//
//  OSLogHandler.swift
//
//
//  Created by Daniel Illescas Romero on 01/01/2020.
//

import Foundation
import os

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public struct OSLoggerHandler: LoggerHandler {

	public init() {}

	public func log(_ parameters: BetterLogger.Parameters) {
		let subsystem = Bundle.main.bundleIdentifier ?? "App"
		let logger = Logger(subsystem: subsystem, category: parameters.loggerName)

		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

		let message = """
		[\(dateFormatter.string(from: date)) | \(parameters.severity) | \(parameters.metadata.file.lastPathComponent):\(parameters.metadata.line):\(parameters.metadata.column) \(parameters.metadata.function.trimmingCharacters(in: .whitespacesAndNewlines))]
		\(_stringRepresentationFrom(parameters.value))
		"""
		let context = _stringRepresentationFromDictionary(parameters.context)

		switch parameters.severity {
		case .debug:
			if parameters.context.isEmpty {
				logger.debug("\(message)")
			} else {
				switch parameters.contextPrivacy {
				case .private:
					logger.debug("\(message)\n\(context, privacy: .private)")
				case .public:
					logger.debug("\(message)\n\(context, privacy: .public )")
				}
			}
		case .verbose:
			if parameters.context.isEmpty {
				logger.notice("\(message)")
			} else {
				switch parameters.contextPrivacy {
				case .private:
					logger.notice("\(message)\n\(context, privacy: .private)")
				case .public:
					logger.notice("\(message)\n\(context, privacy: .public )")
				}
			}
		case .info:
			if parameters.context.isEmpty {
				logger.info("\(message)")
			} else {
				switch parameters.contextPrivacy {
				case .private:
					logger.info("\(message)\n\(context, privacy: .private)")
				case .public:
					logger.info("\(message)\n\(context, privacy: .public )")
				}
			}
		case .warning:
			if parameters.context.isEmpty {
				logger.warning("\(message)")
			} else {
				switch parameters.contextPrivacy {
				case .private:
					logger.warning("\(message)\n\(context, privacy: .private)")
				case .public:
					logger.warning("\(message)\n\(context, privacy: .public )")
				}
			}
		case .error:
			if parameters.context.isEmpty {
				logger.error("\(message)")
			} else {
				switch parameters.contextPrivacy {
				case .private:
					logger.error("\(message)\n\(context, privacy: .private)")
				case .public:
					logger.error("\(message)\n\(context, privacy: .public )")
				}
			}
		case .fatalError:
			if parameters.context.isEmpty {
				logger.fault("\(message)")
			} else {
				switch parameters.contextPrivacy {
				case .private:
					logger.fault("\(message)\n\(context, privacy: .private)")
				case .public:
					logger.fault("\(message)\n\(context, privacy: .public )")
				}
			}
		}
	}
}
