//
//  ProfilePictureView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI

enum ProfileImageType {
    case circle
    case squircle
}

struct ProfilePictureView: View {
    var url: String
    var imageType: ProfileImageType = .circle 
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image.profileImageStyle(imageType: imageType)
            } else {
                Image("profile_placeholder").profileImageStyle(imageType: imageType)
            }
        }
    }
}

extension Image {
    func profileImageStyle(imageType: ProfileImageType) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .modifier(ProfileImageModifier(imageType: imageType))
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
    }
}

struct ProfileImageModifier: ViewModifier {
    var imageType: ProfileImageType
    
    func body(content: Content) -> some View {
        
        switch imageType {
        case .circle:
            content
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.orange, lineWidth: 2)
                )
        case .squircle:
            content.clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
}

#Preview {
    ProfilePictureView(url: "https://picsum.photos/i/237/400/400").frame(width: 150)
}
