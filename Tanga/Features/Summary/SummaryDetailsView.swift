//
//  SummaryDetailsView.swift
//  Tanga
//
//  Created by Rygel Louv on 08/12/2024.
//

import SwiftUI

struct SummaryDetailsView: View {
    
    let summaryId: SummaryId
    @EnvironmentObject var authManager: AuthManager
    
    @StateObject private var viewModel: SummaryDetailsViewModel
    @StateObject private var favoriteViewModel: FavoriteViewModel

    @State private var isSharing = false
    
    init(summaryId: SummaryId) {
        self.summaryId = summaryId
        let sessionManager = SessionManager()
        
        _viewModel = StateObject(wrappedValue:
            SummaryDetailsViewModel(
                summaryRepository: SummaryRepository()
            )
        )
        
        _favoriteViewModel = StateObject(wrappedValue:
            FavoriteViewModel(
                favoriteRepository: FavoriteRepository(),
                summaryRepository: SummaryRepository(),
                protectedActionInteractor: ProtectedActionInteractor(
                    sessionManager: sessionManager,
                    revenuecatController: RevenueCatController()
                )
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        if let summary = viewModel.summary {
                            SummaryHeader(summary: summary)
                            Spacer()
                            VStack(alignment: .leading, spacing: 16) {
                                SummaryLearningsView(summary: summary)
                                
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
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    NavigationLink(destination: AIPromptsView(summaryId: summaryId)) {
                        HStack {
                            Image(systemName: "sparkles")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Circle().fill(.white.opacity(0.2)))
                            
                            Text("Ask Tanga AI")
                                .font(Font.custom("Montserrat", size: 16, relativeTo: .headline))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
                                .padding(.leading, 16)
                        }
                        .frame(height: 56)
                        .padding(.horizontal, 8)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [.navy, .yaleBlue, .cerulean]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.bottom, 16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            await favoriteViewModel.toggleFavorite()
                        }
                        guard let summaryId = viewModel.summary?.id else { return }
                        AnalyticsTracker.shared.track(event: favoriteTapEvent(summaryId: summaryId))
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
                        guard let summaryId = viewModel.summary?.id else { return }
                        AnalyticsTracker.shared.track(event: Events.tapShareSummary(summaryId: summaryId))
                        isSharing = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .frame(width: 20, height: 28)
                            .foregroundColor(Color.silverFoil)
                    }
                }
            }
            .toolbarBackground(Color.white, for: .navigationBar)
            .sheet(isPresented: $isSharing) {
                if let summary = viewModel.summary,
                   let summaryId = summary.id,
                   let imageUrlString = summary.coverImageUrl,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    ShareSheet(shareSummaryId: summaryId, shareImageURL: imageUrl)
                }
            }
        }
        .sheet(isPresented: $favoriteViewModel.showAuth) {
            AuthView()
                .onDisappear {
                    favoriteViewModel.dismissAuth()
                }
        }
        .alert("Error", isPresented: Binding(
            get: { favoriteViewModel.error != nil },
            set: { if !$0 { favoriteViewModel.error = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = favoriteViewModel.error {
                Text(error.localizedDescription)
            }
        }
        .task {
            await viewModel.loadDetails(summaryId: summaryId)
            await favoriteViewModel.loadFavoriteStatus(for: summaryId)
        }
    }
    
    private func favoriteIcon() -> String {
        favoriteViewModel.isFavorite ? "favorite" : "bookmark"
    }
    
    private func favoriteTapEvent(summaryId: String) -> AnalyticsEvent {
        favoriteViewModel.isFavorite
        ? Events.tapRemoveSavedSummary(summaryId: summaryId)
        : Events.tapSaveSummary(summaryId: summaryId)
    }
    
    struct SummaryHeader: View {
        var summary: Summary
        private let protectedActionInteractor = ProtectedActionInteractor(
            sessionManager: SessionManager(),
            revenuecatController: RevenueCatController()
        )
        
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
                        ActionButton(
                            actionType: action,
                            summary: summary,
                            protectedActionInteractor: protectedActionInteractor
                        ).trackTap(event: actionEvent(actionType: action, summaryId: summary.id ?? ""))
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
        
        func actionEvent(actionType: ActionType, summaryId: String) -> AnalyticsEvent {
            switch actionType {
            case .read:
                Events.tapReadSummary(summaryId: summaryId)
            case .listen:
                Events.tapPlayStartAudio(summaryId: summaryId)
            case .graphic:
                Events.tapVisualizeGraphicSummary(summaryId: summaryId)
            }
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
