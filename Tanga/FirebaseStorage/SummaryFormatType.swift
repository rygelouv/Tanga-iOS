//
//  SummaryFormatType.swift
//  Tanga
//
//  Created by Rygel Louv on 03/01/2025.
//
import Foundation

/**
 * Enum representing different types of summary resource formats
 * and their associated filenames.
 */
enum SummaryFormatType: String {
    case cover = "cover.jpg"
    case text = "summary.md"
    case audio = "audio.mp3"
    case podcast = "podcast.mp3"
    case graphic = "graphic.jpg"
    
    /// Returns the associated filename for the format type.
    var filename: String {
        return self.rawValue
    }
}
