//
//  SearchEmptyResultView.swift
//  Tanga
//
//  Created by Rygel Louv on 18/10/2024.
//

import SwiftUI

struct SearchEmptyResultView: View {
    var query: String
        
        var body: some View {
            VStack(alignment: .center, spacing: 16) { // Center-aligned with top arrangement
                Image("graphic_search_empty") // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 10)
                
                Text("No results found for \"\(query)\"")
                    .fontWeight(.bold)
                    .font(Font.custom("Montserrat", size: 24, relativeTo: .title2))
                    .foregroundColor(.silverFoil) // Replace with the appropriate color
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                
                Text("Try refining your search query or explore other categories.")
                    .font(Font.custom("Montserrat", size: 18, relativeTo: .title2))
                    .foregroundColor(.silverFoil)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding() // Add padding as needed
        }
}

#Preview {
    SearchEmptyResultView(query: "Search Query")
}
