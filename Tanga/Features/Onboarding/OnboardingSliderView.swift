//
//  OnboardingSliderView.swift
//  Tanga
//
//  Created by Rygel Louv on 27/09/2024.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var image: String
}

enum OnboardingPages {
    case page1
    case page2
    case page3
    
    var page: OnboardingPage {
        switch self {
            case .page1:
                return OnboardingPage(
                    title: String(localized: "Life-changing books"),
                    description: String(localized: "Dive into the transformative wisdom of best-selling books that have changed lives around the world"),
                    image: String("graphic_reading_glasses_01")
                )
            case .page2:
                return OnboardingPage(
                    title: String(localized: "Choose your format"),
                    description: String(localized: "Whether you prefer reading or listening, enjoy summaries in the format that suits your lifestyle."),
                    image: String("graphic_listening")
                )
            case .page3:
                return OnboardingPage(
                    title: String(localized: "Improve your life"),
                    description: String(localized: "Unlock your full potential with concise and impactful summaries designed to help you grow, learn, and succeed"),
                    image: String("graphic_self_confidence_pana_01")
                )
        }
    }
    
    static var allPages: [OnboardingPage] {   
        return [page1.page, page2.page, page3.page]
    }
}

struct OnboardingPageView: View {
    var page: OnboardingPage
    
    var body: some View {
        ZStack {
            VStack(spacing:20) {
                // Spacer()
                Image(page.image)
                    .resizable()
                    .scaledToFit().padding(.horizontal, 38)
                Color.clear.frame(height: 0.5)
                
                Text(page.title)
                    .fontWeight(.semibold)
                    .font(Font.custom("Montserrat", size: 28, relativeTo: .title))
                    .foregroundColor(.white)
                Color.clear.frame(height: 10)
                Text(page.description)
                    .font(Font.custom("Montserrat", size: 18, relativeTo: .body))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.yaleBlue)
        }
    }
}

struct OnboardingSliderView: View {
    @Binding var path: NavigationPath
    @State private var currentPage = 0
    let pages = OnboardingPages.allPages
    @AppStorage("onboarding_completed") var isOnboardingCompleted: Bool = false
    
    var body: some View {
        VStack(spacing:20) {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, item in
                    OnboardingPageView(page: item).tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .animation(.easeIn, value: currentPage)
            
            let isLastPage = currentPage == min(currentPage + 1, pages.count - 1)
            OnboardingButton(
                isLastPage: isLastPage,
                onNextPage: {
                    currentPage = min(currentPage + 1, pages.count - 1)
                },
                onFinish: {
                    print("Finished onboarding")
                    path = NavigationPath()
                    isOnboardingCompleted = true
                }
            )
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.yaleBlue)
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled(false)
    }
}

struct OnboardingButton: View {
    var isLastPage: Bool = false
    var onNextPage: () -> Void
    var onFinish: () -> Void
    
    var body: some View {
        if isLastPage {
            Button(action: {
                onFinish()
            }) {
                Text("Let's go!")
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 36
                    )
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                    .fontWeight(.bold)
                    .foregroundColor(Color.yaleBlue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
            }.padding(20)
        } else {
            Button(action: {
                withAnimation {
                    onNextPage()
                }
            }) {
                Image("right_arrow")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.yaleBlue)
                    .frame(width: 24, height: 24)
                    .frame(width: 70, height: 70)
                    .background(Color.white)
                    .clipShape(Circle())
            }.padding(20)
        }
    }
}

#Preview {
    OnboardingSliderView(path: .constant(NavigationPath()))
}
