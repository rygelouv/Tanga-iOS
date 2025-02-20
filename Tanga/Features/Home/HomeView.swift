//
//  HomeView.swift
//  Tanga
//
//  Created by Rygel Louv on 05/10/2024.
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var selectionTab: Int
    @StateObject var viewModel = HomeViewModel()
    @StateObject var profileViewModel = ProfileViewModel(revenueCatController: RevenueCatController())
    
    var body: some View {
        VStack {
            if viewModel.uiState.isLoading {
                SummaryRowShimmerAnimation()
            } else {
                Spacer(minLength: 20)
                HomeHeader(path: $navigationPath, selectionTab: $selectionTab, profilePhotoUrl: profileViewModel.photoUrl)
                Spacer(minLength: 25)
                GreetingMessage(userFirsName: profileViewModel.firstName)
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer(minLength: 15)
                    WeeklySummary(weeklySummary: viewModel.uiState.weeklySummary)
                    Spacer(minLength: 30)
                    if let sections = viewModel.uiState.sections {
                        ForEach(sections) { section in
                            HomeSection(section: section)
                            Spacer(minLength: 30)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.loadHomeData()
            profileViewModel.loadProfileData()
        }
    }
    
    struct HomeHeader: View {
        @Binding var path: NavigationPath
        @Binding var selectionTab: Int
        var profilePhotoUrl: String?
        
        var body: some View {
            HStack {
                SearchButton()
                Spacer()
                Button(
                    action: {
                        print("profile picture button tap")
                        selectionTab = 3
                    }
                ) {
                    ProfilePictureView(url: profilePhotoUrl ?? "")
                        .frame(width: 40, height: 40)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    struct GreetingMessage: View {
        var userFirsName: String?
        
        var body: some View {
            HStack {
                Text("Hey,")
                    .font(Font.custom("Montserrat", size: 18, relativeTo: .body))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.auroMetalSaurus)
                Text(userFirsName ?? "Anonymous")
                    .font(Font.custom("Montserrat", size: 18, relativeTo: .body))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.yaleBlue)
                Spacer()
            }
        }
    }
    
    struct WeeklySummary: View {
        var weeklySummary: WeeklySummaryModel?

        var body: some View {
            NavigationLink(destination: SummaryDetailsView(summaryId: weeklySummary?.summary.id ?? "")) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.navy, .yaleBlue, .cerulean]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)

                    HStack {
                        VStack(alignment: .leading) {
                            TagView(title: weeklySummary?.category.name ?? "")
                            Text("Your Free Weekly Summary")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            HStack {
                                Text("Check It Out Now!")
                                    .fontWeight(.regular)
                                    .font(Font.custom("Montserrat", size: 12, relativeTo: .title))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                Image("right_arrow")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        SummaryImageView(url: weeklySummary?.summary.coverImageUrl ?? "")
                    }
                    .padding(20)
                    .multilineTextAlignment(.center)
                }
                .frame(height: 170)
            }.buttonStyle(PlainButtonStyle())
        }
    }
                               
    struct HomeSection: View {
        var section: Section?
        
        var body: some View {
            VStack {
                HStack {
                    Text(section?.category.name ?? "")
                        .fontWeight(.bold)
                        .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                        .foregroundColor(.navy)
                    Spacer()
                    NavigationLink("See all") {
                        CategorySummariesView(categoryId: section?.category.slug ?? "")
                    }.font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.yaleBlue)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                SummaryRowView(summaries: section?.summaries ?? [])
            }
        }
    }
    
    struct GradientView: View {
        var body: some View {
            LinearGradient(
                gradient: Gradient(colors: [.navy, .yaleBlue, .cerulean]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}


#Preview {
    let viewModel = HomeViewModel(uiState: dummyHomeUiState)
    HomeView(navigationPath: .constant(NavigationPath()), selectionTab: .constant(0), viewModel: viewModel)
}
