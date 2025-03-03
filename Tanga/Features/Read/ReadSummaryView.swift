//
//  ReadSummaryView.swift
//  Tanga
//
//  Created by Rygel Louv on 03/01/2025.
//

import MarkdownUI
import SwiftUI

/// This view shows markdown text. It is supposed to show a progress view that progresses as the use scrolls through the content. But this only works when
/// we use Text. When we use Markdown from MarkdownUI package it doesn't work.
/// This must be investigated and fixed later. We can move to using HTML instead of markdown if it makes things easier.
struct ReadSummaryView: View {
    // MARK: - Properties
    @EnvironmentObject var authManager: AuthManager
    var summary: Summary
    
    @StateObject private var favoriteViewModel: FavoriteViewModel
    @StateObject private var readSummaryViewModel: ReadSummaryViewModel
    
    init(summary: Summary) {
        self.summary = summary
        let sessionManager = SessionManager()
        
        _readSummaryViewModel = StateObject(wrappedValue:
            ReadSummaryViewModel(
                fileDownloader: TextFileContentDownloader()
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

    // The progress value (0.0 to 1.0) representing how far the user has scrolled.
    @State private var progress: CGFloat = 0.0
    
    @State private var totalContentHeight: CGFloat = 0
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            
            NavigationStack {
               
                ZStack {
                    if (readSummaryViewModel.loading) {
                        ProgressView().tint(.white)
                    }
                    
                    if let content = readSummaryViewModel.content {
                        VStack(spacing: 0) {
                            // Custom progress view to display scroll progress visually.
                            CustomProgressView(progress: progress)
                                .frame(height: 2)
                                .padding(.top, 10)

                            // ScrollViewReader allows programmatic control of the scroll position.
                            ScrollViewReader { proxy in
                                ScrollView {
                                    // If you replace this with Text(SUMMARY_TEXT) it will start tracking scroll
                                    Markdown(content)
                                        .markdownTextStyle(\.text) {
                                            ForegroundColor(.white)
                                            FontSize(16)
                                         }
                                        .padding()
                                        .background(
                                            GeometryReader { geo in
                                                Color.clear
                                                    .preference(
                                                        // Key for storing offset.
                                                        key: ScrollViewOffsetPreferenceKey.self,
                                                        // Tracks vertical offset of the text.
                                                        value: geo.frame(in: .named("scrollView")).minY
                                                    )
                                                    .onAppear {
                                                        totalContentHeight = geo.size.height
                                                    }
                                            }
                                        )
                                }
                                .coordinateSpace(name: "scrollView") // Names the coordinate space for GeometryReader.
                                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                                    updateProgress(value: value) // Updates progress based on scroll offset.
                                }
                            }
                        }
                    }
                    
                    AudioFloatingActionButton(summary: summary).padding(.trailing, 28).padding(.bottom, 28)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("left-arrow")
                                .resizable()
                                .renderingMode(.template)
                                .font(.system(size: 24))
                                .frame(width: 26, height: 26)
                                .foregroundColor(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // Action for the share button (to be implemented).
                        }) {
                            Image(favoriteIcon())
                                .resizable()
                                .renderingMode(.template)
                                .font(.system(size: 24))
                                .frame(width: 26, height: 26)
                                .foregroundColor(.white)
                        }
                    }
                }
                .toolbarBackground(Color.navy, for: .navigationBar)
                .background(Color.navy)
            }
            .task {
                guard let summaryId = summary.id else { return }
                await favoriteViewModel.loadFavoriteStatus(for: summaryId)
                readSummaryViewModel.fetchContent(summaryId: summaryId)
            }
        }
    }

    // MARK: - Helper Functions

    // Returns the icon name based on whether the summary is a favorite.
    private func favoriteIcon() -> String {
        favoriteViewModel.isFavorite ? "favorite" : "bookmark"
    }

    // Updates the scroll progress based on the offset value.
    private func updateProgress(value: CGFloat) {
        let scrollableHeight = totalContentHeight - UIScreen.main.bounds.height
        guard scrollableHeight > 0 else { return }
        let clampedValue = max(0, min(-value / scrollableHeight, 1))
        progress = clampedValue
    }

    // MARK: - Custom Progress View

    struct CustomProgressView: View {
        let progress: CGFloat // The progress value to display (0.0 to 1.0).

        var body: some View {
            GeometryReader { geometry in // Measures the available width for the progress bar.
                ZStack(alignment: .leading) {
                    // Background bar indicating the total progress.
                    Rectangle()
                        .frame(width: geometry.size.width, height: 2)
                        .opacity(0.3)
                        .foregroundColor(.yaleBlue)

                    // Foreground bar representing the current progress.
                    Rectangle()
                        .frame(
                            width: min(progress * geometry.size.width, geometry.size.width), // Width based on progress.
                            height: 2
                        )
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

// MARK: - ScrollView Offset Preference Key

// A preference key to track the vertical offset of the scroll view's content.
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue() // Updates the preference value with the latest offset.
    }
}

#if DEBUG
#Preview {
    ReadSummaryView(summary: dummySummaries[0])
}
#endif
