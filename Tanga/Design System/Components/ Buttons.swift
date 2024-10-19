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
    var leftIcon: String
    var text: String
    
    var body: some View {
        Button(action: {
            print("Tanga button tapped")
            onButtonTap()
        }) {
            ZStack {
                HStack {
                    Image(leftIcon).resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    // leftIcon
                    Spacer()
                }.padding(.leading, 30)
                Text(text)
                    .font(Font.custom("Montserrat", size: 15, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 66)
        }
        .background(Color.yaleBlue)
        .cornerRadius(16)
    }
}

#Preview {
    TangaButton(onButtonTap: {}, leftIcon: "search", text: "Explore Summaries")
}

#Preview {
    SearchButton()
}
