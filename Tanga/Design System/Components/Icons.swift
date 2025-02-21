//
//  Icons.swift
//  Tanga
//
//  Created by Rygel Louv on 21/02/2025.
//

import SwiftUI

/// A reusable component for displaying icons consistently
struct CommonIcon: View {
    /// The name of the icon to display
    let name: String
    /// The color of the icon
    let foregroundColor: Color
    /// The size of the icon
    let size: CGFloat
    
    var body: some View {
        Image(name)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundColor(foregroundColor)
    }
}
