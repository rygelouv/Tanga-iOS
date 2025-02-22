//
//  LogTree.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//

protocol LogTree {
    func log(_ level: LogLevel, message: String, file: String, function: String, line: Int)
}
