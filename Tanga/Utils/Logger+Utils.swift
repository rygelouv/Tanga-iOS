//
//  Logger+Utils.swift
//  Tanga
//
//  Created by Ibrahima Ciss on 28/01/2025.
//

import OSLog

extension Logger {
  private static let identifier = Bundle.main.bundleIdentifier ?? ""
  
    @available(*, deprecated, message: "use TangaLogger instead")
  static let data = Logger(subsystem: identifier, category: "Data")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let designSystem = Logger(subsystem: identifier, category: "DesignSystem")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let audioPlayer = Logger(subsystem: identifier, category: "AudioPlayer")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let authentication = Logger(subsystem: identifier, category: "Authentication")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let library = Logger(subsystem: identifier, category: "Library")
    @available(*, deprecated)
  static let profile = Logger(subsystem: identifier, category: "Profile")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let subscriptions = Logger(subsystem: identifier, category: "Subscriptions")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let summary = Logger(subsystem: identifier, category: "Summary")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let onboarding = Logger(subsystem: identifier, category: "Onboarding")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let search = Logger(subsystem: identifier, category: "Search")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let settings = Logger(subsystem: identifier, category: "Settings")
    @available(*, deprecated, message: "use TangaLogger instead")
  static let notifications = Logger(subsystem: identifier, category: "Notifications")

}
