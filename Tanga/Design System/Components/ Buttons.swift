//
//  Buttons.swift
//  Tanga
//
//  Created by Rygel Louv on 09/10/2024.
//

import SwiftUI

struct SearchButton: View {
    var body: some View {
        NavigationLink(destination: SearchView()) {
            HStack {
                Image("search")
                    .renderingMode(.template)
                    .foregroundColor(.yaleBlue)
                
                Text("Explore").frame(minHeight: 36)
            }
        }.buttonStyle(SearchButtonStyle())
    }

    struct SearchButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 16)
                .padding(.vertical, 3)
                .background(Color.yaleBlue.opacity(0.1))
                .cornerRadius(100)
                .font(Font.custom("Montserrat", size: 14, relativeTo: .headline))
                .fontWeight(.semibold)
                .foregroundColor(.yaleBlue)
                .frame(minHeight: 36)
        }
    }
}

struct TangaButton: View {
    var onButtonTap: () -> Void
    var leftIcon: String? = nil // leftIcon is optional
    var text: String
    var size: ButtonSize = .small // Default to "small" size
    
    enum ButtonSize {
        case big
        case small
    }
    
    var body: some View {
        Button(action: {
            onButtonTap()
        }) {
            ZStack {
                HStack {
                    // Show the left icon only if provided
                    if let icon = leftIcon {
                        Image(icon).resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                    Spacer()
                }.padding(.leading, 30)
                
                Text(text)
                    .font(Font.custom("Montserrat", size: textSize, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 66)
        }
        .background(Color.yaleBlue)
        .cornerRadius(16)
    }
    
    private var textSize: CGFloat {
        size == .big ? 18 : 15
    }
}

struct TangaPremiumButton: View {
    var onButtonTap: () -> Void
    
    var body: some View {
        Button(action: {
            onButtonTap()
        }) {
            HStack {
               // Icon on the left
               Image("crown")
                   .resizable()
                   .frame(width: 36, height: 36)
                   .foregroundColor(.none)
                   .padding(8)
                   .background(Circle().fill(.white))
                   .padding(.leading, 12) // Padding to position the icon
               
               // Text on the right
               Text("Get Tanga Premium")
                   .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                   .fontWeight(.bold)
                   .foregroundColor(.white)
                   .padding(.trailing, 20)
                   .padding(.leading, 16)
           }
           .frame(minHeight: 66)
           .padding(.vertical, 4)
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [.navy, .yaleBlue, .cerulean]),
            startPoint: .leading,
            endPoint: .trailing
        ))
        .cornerRadius(40)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Big button with icon
        TangaButton(
            onButtonTap: { print("Big button tapped") },
            text: "Contact Us",
            size: .big
        )
        
        // Small button without icon
        TangaButton(
            onButtonTap: { print("Small button tapped") },
            leftIcon: "search",
            text: "Explore Summaries",
            size: .small
        )
        
        // Premium button
        TangaPremiumButton(onButtonTap: { print("Premium button tapped")})
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview {
    SearchButton()
}
