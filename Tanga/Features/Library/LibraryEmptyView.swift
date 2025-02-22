//
//  LibraryEmptyView.swift
//  Tanga
//
//  Created by Rygel Louv on 09/10/2024.
//

import SwiftUI
import Sentry

struct LibraryEmptyView: View {
    var body: some View {
       VStack(alignment: .leading) {
           Text("Library")
               .fontWeight(.bold)
               .font(Font.custom("Montserrat", size: 28, relativeTo: .title))
               .foregroundColor(.navy)
           VStack {
               Spacer()
               Text("Your Library is Empty")
                   .fontWeight(.semibold)
                   .font(Font.custom("Montserrat", size: 28, relativeTo: .title))
                   .foregroundColor(.silverFoil)
               Spacer()
               EmptyLibraryImage()
               Spacer()
               TangaNavButton(destination: SearchView(), leftIcon: "search", text: "Explore Summaries").padding()
               Spacer()
           }
       }.padding()
    }
    
    struct EmptyLibraryImage: View {
        var body: some View {
            Image("empty_library")
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}

#Preview {
    LibraryEmptyView()
}
