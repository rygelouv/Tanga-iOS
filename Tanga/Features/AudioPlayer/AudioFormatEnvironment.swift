//
//  AudioFormatEnvironment.swift
//  Tanga
//
//  Created by Rygel Louv on 14/05/2025.
//

import SwiftUI

// Define an environment key for the audio format
struct AudioFormatEnvironmentKey: EnvironmentKey {
    static let defaultValue: AudioFormat = .audiobook
}

// Extend EnvironmentValues to access the audio format
extension EnvironmentValues {
    var audioFormat: AudioFormat {
        get { self[AudioFormatEnvironmentKey.self] }
        set { self[AudioFormatEnvironmentKey.self] = newValue }
    }
}

// Extension to make it easy to set the audio format in the environment
extension View {
    func audioFormat(_ format: AudioFormat) -> some View {
        environment(\.audioFormat, format)
    }
}
