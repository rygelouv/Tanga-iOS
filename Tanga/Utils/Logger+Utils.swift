//
//  Logger+Utils.swift
//  Tanga
//
//  Created by Ibrahima Ciss on 28/01/2025.
//

import OSLog

extension Logger {
  private static let identifier = Bundle.main.bundleIdentifier ?? ""
  
  static let data = Logger(subsystem: identifier, category: "Data")
  static let designSystem = Logger(subsystem: identifier, category: "DesignSystem")
  static let audioPlayer = Logger(subsystem: identifier, category: "AudioPlayer")
  static let authentication = Logger(subsystem: identifier, category: "Authentication")
  static let library = Logger(subsystem: identifier, category: "Library")
  static let profile = Logger(subsystem: identifier, category: "Profile")
  static let subscriptions = Logger(subsystem: identifier, category: "Subscriptions")
  static let summary = Logger(subsystem: identifier, category: "Summary")
  static let onboarding = Logger(subsystem: identifier, category: "Onboarding")
  static let search = Logger(subsystem: identifier, category: "Search")
  static let settings = Logger(subsystem: identifier, category: "Settings")

}
