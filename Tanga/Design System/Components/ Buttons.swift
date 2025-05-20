//
//  Buttons.swift
//  Tanga
//
//  Created by Rygel Louv on 09/10/2024.
//

import OSLog
import SwiftUI

/// Defines the size variants available for buttons
enum ButtonSize {
    /// Larger button size with 18pt text
    case big
    /// Standard button size with 15pt text
    case small
    
    /// The text size associated with this button size
    var textSize: CGFloat {
        self == .big ? 18 : 15
    }
}

/// Defines the visual style variants available for buttons
enum ButtonVariation {
    /// Primary action button style
    case primary
    /// Secondary action button style
    case secondary
    /// Tertiary action button style (outline)
    case tertiary
    /// Destructive action button style
    case danger
    
    /// The visual styling data for this variation
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

/// Contains the visual styling data for button variations
struct ButtonVariationData {
    /// The background color of the button
    var backgroundColor: Color
    /// The text and icon color of the button
    var foregroundColor: Color
}

/// A custom button style for search functionality
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

/// A custom button style for navigation buttons
struct TangaNavButtonStyle: ButtonStyle {
    /// The visual variation to apply to the button
    var variation: ButtonVariation
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 66)
            .background(variation.data.backgroundColor)
            .cornerRadius(16)
    }
}

// MARK: - Common Styles and Components


/// A view modifier that applies common button styling
private struct CommonButtonModifier: ViewModifier {
    /// The visual variation to apply
    let variation: ButtonVariation
    /// The minimum height of the button
    let minHeight: CGFloat
    /// The corner radius of the button
    let cornerRadius: CGFloat
    
    init(
        variation: ButtonVariation,
        minHeight: CGFloat = 66,
        cornerRadius: CGFloat = 16
    ) {
        self.variation = variation
        self.minHeight = minHeight
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .background(variation.data.backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

/// A reusable component for displaying text consistently
private struct CommonButtonText: View {
    /// The text to display
    let text: String
    /// The size of the text
    let size: CGFloat
    /// The color of the text
    let color: Color
    /// The font weight of the text
    var fontWeight: Font.Weight = .bold
    
    var body: some View {
        Text(text)
            .font(Font.custom("Montserrat", size: size, relativeTo: .headline))
            .fontWeight(fontWeight)
            .foregroundColor(color)
    }
}

/// A custom navigation button component that uses the Tanga design system
struct TangaNavButton<Destination: View>: View {
    /// The destination view to navigate to
    var destination: Destination
    /// Optional icon to display on the left side of the button
    var leftIcon: String?
    /// The text to display in the button
    var text: String
    /// The size variant of the button
    var size: ButtonSize = .small
    /// The visual style variant of the button
    var variation: ButtonVariation = .primary
    
    var body: some View {
        NavigationLink(destination: destination) {
            ButtonContentView(
                leftIcon: leftIcon,
                text: text,
                size: size,
                variation: variation
            )
        }
        .buttonStyle(TangaNavButtonStyle(variation: variation))
    }
}

/// A standard button component that uses the Tanga design system
struct TangaButton: View {
    /// The action to perform when the button is tapped
    let onButtonTap: () -> Void
    /// Optional icon to display on the left side of the button
    var leftIcon: String?
    /// The text to display in the button
    let text: String
    /// The size variant of the button
    var size: ButtonSize = .small
    /// The visual style variant of the button
    var variation: ButtonVariation = .primary
    
    var body: some View {
        Button(action: onButtonTap) {
            ButtonContentView(
                leftIcon: leftIcon,
                text: text,
                size: size,
                variation: variation
            )
        }
        .modifier(CommonButtonModifier(variation: variation))
    }
}

/// A reusable component for button content layout
private struct ButtonContentView: View {
    let leftIcon: String?
    let text: String
    let size: ButtonSize
    let variation: ButtonVariation
    
    var body: some View {
        ZStack {
            HStack {
                if let icon = leftIcon {
                    CommonIcon(
                        name: icon,
                        foregroundColor: variation.data.foregroundColor,
                        size: 28
                    )
                    .padding(.leading, 10)
                }
                Spacer()
            }.padding(.leading, 30)
            
            CommonButtonText(
                text: text,
                size: size.textSize,
                color: variation.data.foregroundColor
            )
        }
    }
}

/// A specialized button for search functionality
struct SearchButton: View {
    var body: some View {
        NavigationLink(destination: SearchView()) {
            HStack {
                CommonIcon(
                    name: "search",
                    foregroundColor: .yaleBlue,
                    size: 24
                )
                
                Text("Explore").frame(minHeight: 36)
            }
        }.buttonStyle(SearchButtonStyle())
    }
}

/// A button for profile actions that executes a closure when tapped
struct ProfileContentAction: View {
    let imageName: String
    let text: String
    let color: Color
    var paddingValue: CGFloat = 0
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            ProfileActionContent(
                imageName: imageName,
                text: text,
                color: color,
                paddingValue: paddingValue
            )
        }.buttonStyle(PlainButtonStyle())
    }
}

/// A navigation button for profile actions
struct ProfileContentNavAction<Destination: View>: View {
    var destination: Destination
    let imageName: String
    let text: String
    let color: Color
    var paddingValue: CGFloat = 0

    var body: some View {
        NavigationLink(destination: destination) {
            ProfileActionContent(
                imageName: imageName,
                text: text,
                color: color,
                paddingValue: paddingValue
            )
        }.buttonStyle(PlainButtonStyle())
    }
}

/// A reusable component for profile action content layout
private struct ProfileActionContent: View {
    let imageName: String
    let text: String
    let color: Color
    let paddingValue: CGFloat
    
    var body: some View {
        HStack(spacing: 16) {
            CommonIcon(name: imageName, foregroundColor: color, size: 24)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.2)))
            
            CommonButtonText(text: text, size: 16, color: .navy, fontWeight: Font.Weight.medium)
            
            Spacer()
            
            CommonIcon(name: "right-chevron", foregroundColor: .gray, size: 16)
        }
        .contentShape(Rectangle())
        .padding(paddingValue)
    }
}

/// A specialized button for premium subscription
struct TangaPremiumButton: View {
    
    var body: some View {
        NavigationLink(destination: SubscriptionsView()) {
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
           }.frame(minHeight: 66)
                .padding(.vertical, 4)
                .background(LinearGradient(
                    gradient: Gradient(colors: [.navy, .yaleBlue, .cerulean]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .cornerRadius(40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// A floating action button for audio
/*struct AudioFloatingActionButton: View {
    var summary: Summary
    
    init(summary: Summary) {
        self.summary = summary
    }
    
    var body: some View {
        NavigationLink(destination: AudioPlayerView(summary: summary, audioFormat: .audiobook)) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
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
            }
        }.buttonStyle(PlainButtonStyle())
    }
}*/

/// A circular close button with customizable styling
struct CloseButtonView: View {
    /// The action to perform when dismissed
    let dismiss: () -> Void
    /// The visual style variant
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

#if DEBUG
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
        TangaPremiumButton()
        
        //AudioFloatingActionButton(summary: dummySummaries[0])
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
#endif

#Preview {
    SearchButton()
}
