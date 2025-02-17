//
//  LandingView.swift
//  Tanga
//
//  Created by Rygel Louv on 22/09/2024.
//

import OSLog
import SwiftUI

struct LandingView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Image("landing_image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0, green: 0.094, blue: 0.29, opacity: 0),
                    Color(red: 0, green: 0.094, blue: 0.29, opacity: 1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            ).edgesIgnoringSafeArea(.all)
            
            
            VStack(spacing: 35) {
                Spacer()
                
                Text("The simplest, most focused way to experience life-changing book summaries.")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Montserrat", size: 24, relativeTo: .title2))
                    .fontWeight(.regular)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                // Color.clear.frame(height: 5)
                
                TangaButton(
                    onButtonTap: {
                        path.append(NavigationDestinations.Onboarding)
                    },
                    text: "Get Started",
                    size: .small,
                    variation: .secondary
                )
            }.padding(50)
        }
    }
}

#Preview {
    LandingView(path: .constant(NavigationPath()))
}
