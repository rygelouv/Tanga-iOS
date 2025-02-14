//
//  Buttons.swift
//  Tanga
//
//  Created by Rygel Louv on 09/10/2024.
//

import OSLog
import SwiftUI

enum ButtonSize {
    case big
    case small
}

enum ButtonVariation {
    case primary
    case secondary
    case tertiary
    case danger
    
    // Side note: this pattern sucks in swift. Having to add an extra "data" property is confusing
    // I wish we could just pass ButtonVariableData to case ButtonVariation directly
    var data: ButtonVariationData {
        switch self {
        case .primary:
            return ButtonVariationData(
                backgroundColor: .yaleBlue,
                foregroundColor: .white
            )
        case .secondary:
            return ButtonVariationData(
                backgroundColor: .cerulean,
                foregroundColor: .white
            )
        case .tertiary:
            return ButtonVariationData(
                backgroundColor: .white,
                foregroundColor: .yaleBlue
            )
        case .danger:
            return ButtonVariationData(
                backgroundColor: .clear,
                foregroundColor: .red
            )
        }
    }
}


struct TangaNavButton<Destination: View>: View {
    var destination: Destination
    var leftIcon: String? = nil // leftIcon is optional
    var text: String
    var size: ButtonSize = .small // Default to "small" size
    var variation: ButtonVariation = .primary
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                HStack {
                    // Show the left icon only if provided
                    if let icon = leftIcon {
                        Image(icon).resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 28, height: 28)
                            .foregroundColor(variation.data.foregroundColor)
                            .padding(.leading, 10)
                    }
                    Spacer()
                }.padding(.leading, 30)
                
                Text(text)
                    .font(Font.custom("Montserrat", size: textSize, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(variation.data.foregroundColor)
            }
            .frame(maxWidth: .infinity, minHeight: 66)
        }
        .buttonStyle(TangaNavButtonStyle(variation: variation))
    }
    
    struct TangaNavButtonStyle: ButtonStyle {
        var variation: ButtonVariation
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(variation.data.backgroundColor)
                .cornerRadius(16)
        }
    }
    
    private var textSize: CGFloat {
        size == .big ? 18 : 15
    }
}

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

struct ButtonVariationData {
    var backgroundColor: Color
    var foregroundColor: Color
}

struct TangaButton: View {
    var onButtonTap: () -> Void
    var leftIcon: String? = nil // leftIcon is optional
    var text: String
    var size: ButtonSize = .small // Default to "small" size
    var variation: ButtonVariation = .primary
    
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
                            .foregroundColor(variation.data.foregroundColor)
                            .padding(.leading, 10)
                    }
                    Spacer()
                }.padding(.leading, 30)
                
                Text(text)
                    .font(Font.custom("Montserrat", size: textSize, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(variation.data.foregroundColor)
            }
            .frame(maxWidth: .infinity, minHeight: 66)
        }
        .background(variation.data.backgroundColor)
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
        }
        .frame(minHeight: 66)
        .padding(.vertical, 4)
        .background(LinearGradient(
            gradient: Gradient(colors: [.navy, .yaleBlue, .cerulean]),
            startPoint: .leading,
            endPoint: .trailing
        ))
        .cornerRadius(40)
    }
}

struct AudioFloatingActionButton: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    // Your FAB action here
                }) {
                    HStack {
                        Image("o_listen")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .frame(width: 24, height: 24)
                        
                        Text("Play")
                            .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading, 4)
                    }
                    .padding(.leading, 18)
                    .padding(.trailing, 18)
                    .frame(minHeight: 52)
                    .background(Color.orange)
                    .cornerRadius(40)
                    .shadow(radius: 4, x: 0, y: 2)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

struct CloseButtonView: View {
    let dismiss: () -> Void
    var variation: ButtonVariation = .primary

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(variation.data.foregroundColor)
                    .frame(width: 38, height: 38)
            }
            .background(variation.data.foregroundColor.opacity(0.2)) // We use foregroud color on background here
            .clipShape(Circle())
            .frame(width: 48, height: 48)
        }
    }
}

struct ProfileContentAction: View {
    var imageName: String
    var text: String
    var color: Color
    var paddingValue: CGFloat = 0
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 16) {
                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(color)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.2)))
                
                Text(text)
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                    .foregroundColor(.navy)
                
                Spacer()
                
                Image("right-chevron")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle()) // Ensures the entire row is clickable
            .padding(paddingValue)
        }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        // Big button with icon
        TangaButton(
            onButtonTap: { Logger.designSystem.log("Big button tapped") },
            text: "Contact Us",
            size: .big
        )
        
        // Small button without icon
        TangaButton(
            onButtonTap: { Logger.designSystem.log("Small button tapped") },
            leftIcon: "search",
            text: "Explore Summaries",
            size: .small
        )
        
        // Premium button
        TangaPremiumButton(onButtonTap: { Logger.designSystem.log("Premium button tapped")})
        
        AudioFloatingActionButton()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview {
    SearchButton()
}
