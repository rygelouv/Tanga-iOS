//
//  LandingView.swift
//  Tanga
//
//  Created by Rygel Louv on 22/09/2024.
//

import SwiftUI

struct LandingView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Image("reading_background_image")
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
                
                Text("15 Minutes summaries of life-changing books")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Montserrat", size: 24, relativeTo: .title2))
                    .fontWeight(.regular)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20)
                // Color.clear.frame(height: 5)
                
                Button(action: {
                    print("Button tapped")
                    path.append(NavigationDestinations.Onboarding)
                }) {
                    Text("Get Started")
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 36
                        )
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.cerulean)
                        .cornerRadius(16)
                }
            }.padding(50)
        }
    }
}

#Preview {
    LandingView(path: .constant(NavigationPath()))
}
