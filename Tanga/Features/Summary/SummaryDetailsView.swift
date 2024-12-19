//
//  SummaryDetailsView.swift
//  Tanga
//
//  Created by Rygel Louv on 08/12/2024.
//

import SwiftUI

struct SummaryDetailsView: View {
    let summaryId: SummaryId
    @StateObject var viewModel: SummaryDetailsViewModel = SummaryDetailsViewModel(summaryRepository: SummaryRepository())
    @StateObject var favoriteViewModel: FavoriteViewModel = FavoriteViewModel(
        favoriteRepository: FavoriteRepository(),
        summaryRepository: SummaryRepository()
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let summary = viewModel.summary {
                        SummaryHeader(summary: summary)
                        Spacer()
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Introduction")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                                .foregroundColor(Color.navy)
                                .padding(.top, 8)
                            if let synopsis = summary.synopsis {
                                ExpandableText(text: synopsis)
                            }
                        }.padding()
                        Spacer()
                        if let recommendations = viewModel.recommendations {
                            RecommendationSection(summaries: recommendations)
                        }
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        favoriteViewModel.toggleFavorite()
                    }) {
                        Image(favoriteIcon())
                            .resizable()
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.silverFoil)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Your share action here
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .frame(width: 20, height: 28)
                            .foregroundColor(Color.silverFoil)
                    }
                }
            }.toolbarBackground(Color.white, for: .navigationBar)
        }.onAppear {
            viewModel.loadDetails(summaryId: summaryId)
            favoriteViewModel.getFavorite(summaryId: summaryId)
        }
    }
    
    private func favoriteIcon() -> String {
        favoriteViewModel.isFavorite ? "favorite" : "bookmark"
    }
    
    struct SummaryHeader: View {
        var summary: Summary
        
        var body: some View {
            VStack() {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 16) {

                        SummaryImageView(url: summary.coverImageUrl ?? "").frame(width: 124)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text(summary.title ?? "")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                                .foregroundColor(Color.navy)
                            
                            Text(summary.author ?? "")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 16, relativeTo: .title2))
                                .foregroundStyle(Color.auroMetalSaurus)
                            
                            HStack {
                                Image(systemName: "headphones")
                                    .foregroundColor(.yaleBlue)
                                Text((summary.playingLength ?? "00:00").appending(" min"))
                                    .fontWeight(.semibold)
                                    .font(Font.custom("Montserrat", size: 14, relativeTo: .title))
                                    .foregroundColor(Color.yaleBlue)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                }
                .padding()
                
                // Action buttons
                HStack(spacing: 30) {
                    ActionButton(icon: "o_read", title: "Read", isDisabled: false)
                    ActionButton(icon: "o_listen", title: "Listen", isDisabled: false)
                    ActionButton(icon: "o_mindmap", title: "Visualize", isDisabled: true)
                }
                .padding()
            }
            .background(Color.white)
                .clipShape(
                    RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 40)
                )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .frame(maxWidth: .infinity)
        }
    }

    struct ActionButton: View {
        let icon: String
        let title: String
        let isDisabled: Bool
        
        var body: some View {
            VStack(spacing: 0){
                Image(icon)
                    .renderingMode(.template)
                    .font(.system(size: 24))
                    .foregroundColor(textColor)
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 18)
                    .padding(.top, 4)
                    
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                    .padding(.bottom, 12)
                
            }
            .background(backgroundColor.opacity(0.1))
                .cornerRadius(12)
        }
        
        private var textColor: Color {
            isDisabled ? Color.tangaGray.opacity(0.38) : Color.yaleBlue
        }
        
        private var backgroundColor: Color {
            isDisabled ? Color.tangaGray : Color.yaleBlue
        }
    }
    
    struct RecommendationSection: View {
        var summaries: [Summary]?
        
        var body: some View {
            VStack {
                HStack {
                    Text("Recommended summaries")
                        .fontWeight(.bold)
                        .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                        .foregroundColor(.navy)
                    Spacer()
                }
                
                SummaryRowView(summaries: summaries ?? [])
            }.padding()
        }
    }
}

#Preview {
    SummaryDetailsView(summaryId: .init("1"))
}
