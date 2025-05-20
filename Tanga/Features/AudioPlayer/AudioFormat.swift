//
//  AudioFormat.swift
//  Tanga
//
//  Created by Rygel Louv on 13/05/2025.
//

import Foundation

enum AudioFormat {
    case podcast
    case audiobook
    
    var title: String {
        switch self {
        case .podcast:
            return "Podcast Summary"
        case .audiobook:
            return "Audiobook Summary"
        }
    }
    
    var description: String {
        switch self {
        case .podcast:
            return "Listen in a podcast discussion format"
        case .audiobook:
            return "Hear the complete summary narrated"
        }
    }
    
    var imageName: String {
        switch self {
        case .podcast:
            return "Podcast-bro"
        case .audiobook:
            return "Audiobook-bro"
        }
    }
}
