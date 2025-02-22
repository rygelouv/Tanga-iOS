//
//  OSLogger.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//
import OSLog

class OSLogger: LogTree {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "app.books.Tanga", category: "General")

    func log(_ level: LogLevel, message: String, file: String, function: String, line: Int) {
        let logMessage = "[\(level)] \(message) (\(file):\(line) \(function))"
        
        switch level {
        case .debug:
            logger.debug("\(logMessage)")
        case .info:
            logger.info("\(logMessage)")
        case .warning:
            logger.warning("\(logMessage)")
        case .error:
            logger.error("\(logMessage)")
        }
    }
}
