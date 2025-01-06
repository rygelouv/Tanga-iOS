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
                            SummaryLearningsView(keyLearnings: summary.keyLearnings ?? [])
                            
                            Text("Introduction")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 16, relativeTo: .title))
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
                    ForEach(ActionType.allCases, id: \.self) { action in
                        ActionButton(actionType: action, summary: summary)
                    }
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
    
    struct RecommendationSection: View {
        var summaries: [Summary]?
        
        var body: some View {
            VStack {
                HStack {
                    Text("Recommended summaries")
                        .fontWeight(.bold)
                        .font(Font.custom("Montserrat", size: 16, relativeTo: .title))
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
