//
//  LogLevel.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//

import OSLog
import FirebaseCrashlytics

enum LogLevel {
    case debug, info, warning, error

    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        }
    }
}
