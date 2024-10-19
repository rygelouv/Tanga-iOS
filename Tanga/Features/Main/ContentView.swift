//
//  MainView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selection = 1
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                HomeView(navigationPath: $navigationPath).tabItem {
                    CustomTabItem(imageName: selection == 1 ? "home_on" : "home_off", topPadding: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(1)
                .background(Color.cultured)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.white, for: .tabBar)
                
                LibraryView().tabItem {
                    CustomTabItem(imageName: selection == 2 ? "library_on" : "library_off", topPadding: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(2)
                .background(Color.cultured)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.white, for: .tabBar)
                
                ProfileView().tabItem {
                    CustomTabItem(imageName: selection == 3 ? "settings_on" : "settings_off", topPadding: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(3)
                .background(Color.cultured)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.white, for: .tabBar)
            }.background(Color.cultured)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.light)
    }
    
    struct CustomTabItem: View {
        let imageName: String
        let topPadding: CGFloat
        
        var body: some View {
            VStack(spacing: 0) {
                Spacer().frame(height: topPadding)
                Image(imageName)
            }
        }
    }
}

#Preview {
    ContentView(navigationPath: .constant(NavigationPath()))
}
