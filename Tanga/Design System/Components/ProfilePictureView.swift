//
//  ProfilePictureView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI

struct ProfilePictureView: View {
    var url: String
    
    var body: some View {
        AsyncImage(
            url: URL(string: url)) { phase in
            if let image = phase.image {
                image.profileImageStyle()
            } else {
                Image("profile_placeholder").profileImageStyle()
            }
        }
    }
}

extension Image {
    func profileImageStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.orange, lineWidth: 2)
            )
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ProfilePictureView(url: "https://picsum.photos/i/237/400/400")
}
