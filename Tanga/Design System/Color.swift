//
//  Color.swift
//  Tanga
//
//  Created by Rygel Louv on 28/09/2024.
//

import SwiftUI

extension Color {

    // Blue Tones
    static let yaleBlue = Color(hex: "0F4C90")
    static let cerulean = Color(hex: "1F91DD")
    static let navy = Color(hex: "001849") 
    static let babyBlueEyes = Color(hex: "A8C8FF")
    static let oxfordBlueTransp = Color(hex: "00001849")

    // White Tones
    static let azureishWhite = Color(hex: "D6E3FF")
    static let water = Color(hex: "CEE5FF")

    // Gray Tones
    static let cultured = Color(hex: "F6F3F6")
    static let gray = Color(hex: "43474E")
    static let auroMetalSaurus = Color(hex: "74777F")
    static let silverFoil = Color(hex: "AFAFAF")
    static let crayola = Color(hex: "9DB3B8")

    // Orange Tones
    static let orange = Color(hex: "FA974A")
    static let orangeTransparent = Color(hex: "33FA974A")

    // Red Tones
    static let red = Color(hex: "BA1A1A")
    static let darkChocolate = Color(hex: "410002")
    static let palePink = Color(hex: "FFDAD6")

    // Standard Tones
    static let white = Color.white
    static let black = Color.black

    // Transparent Tones
    static let navyTransparent = Color(hex: "1A115A8E")

    // Other Tones
    // Profile/Setting colors
    static let profileYellow = Color(hex: "EFCC59")
    static let profileYellowBackground = Color(hex: "FCEFD0")
    static let profileGreen = Color(hex: "5AAF75")
    static let profileGreenBackground = Color(hex: "D4F4DC")
    static let profileRed = Color(hex: "D25F64")
    static let profileRedBackground = Color(hex: "FDD8D8")
    static let profilePurple = Color(hex: "5D62CD")
    static let profilePurpleBackground = Color(hex: "D7DAFE")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

