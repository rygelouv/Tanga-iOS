//
//  TangaLogger.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//

import SwiftUI
import Foundation

final class TangaLogger {
    static let shared = TangaLogger()
    private var trees: [LogTree] = []

    private init() {}

    func plant(_ tree: LogTree) {
        trees.append(tree)
    }
    
    private func log(_ level: LogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        trees.forEach { $0.log(level, message: message, file: file, function: function, line: line) }
    }

    // MARK: - Public API for Fluent Syntax
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
    
    // utility functions - mostly for testing
    func getTreeCount() -> Int {
        return trees.count
    }

    func reset() {
        trees.removeAll()
    }
}
