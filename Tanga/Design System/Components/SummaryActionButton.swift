//
//  SummaryActionButton.swift
//  Tanga
//
//  Created by Rygel Louv on 03/01/2025.
//

import SwiftUI
import OSLog
import Combine

struct ActionButton: View {
    let actionType: ActionType
    let summary: Summary
    let protectedActionInteractor: ProtectedActionInteractor
    
    @State private var showAuth = false
    @State private var showSubscription = false
    @State private var showAudioFormatSelection = false
    @State private var actionCheckResult: ProtectedActionCheckResult?
    
    // Navigation state
    @State private var navigateToAudioPlayer = false
    @State private var navigateToReadSummary = false
    @State private var navigateToRichInsights = false
    @State private var selectedAudioFormat: AudioFormat = .audiobook
    
    var body: some View {
        Button(action: {
            checkProtectedAction()
        }) {
            VStack(spacing: 0) {
                Image(actionType.icon)
                    .renderingMode(.template)
                    .font(.system(size: 24))
                    .foregroundColor(textColor)
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 18)
                    .padding(.top, 4)
                
                Text(actionType.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                    .padding(.bottom, 12)
            }
            .background(backgroundColor.opacity(0.1))
            .cornerRadius(12)
        }
        .sheet(isPresented: $showAuth) {
            AuthView()
                .onDisappear {
                    showAuth = false
                }
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionsView()
                .onDisappear {
                    showSubscription = false
                }
        }
        .sheet(isPresented: $showAudioFormatSelection) {
            AudioFormatSelectionView(
                summary: summary,
                isPresented: $showAudioFormatSelection,
                onFormatSelected: { format in
                    print("✅ Format selected in action button: \(format)")
                    selectedAudioFormat = format
                    navigateToAudioPlayer = true
                }
            )
            .presentationDetents([.medium])
        }
        // Individual NavigationLinks for each destination type
        .background(
            NavigationLink(destination: AudioPlayerView(summary: summary, audioFormat: selectedAudioFormat), isActive: $navigateToAudioPlayer) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: ReadSummaryView(summary: summary), isActive: $navigateToReadSummary) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: 
                summary.id.flatMap { id in 
                    summary.coverImageUrl.map { url in 
                        RichInsightsView(summaryId: id, bookCoverUrl: url)
                    }
                }, isActive: $navigateToRichInsights) {
                EmptyView()
            }
        )
    }
    
    private var textColor: Color {
        actionType.isDisabled ? Color.tangaGray.opacity(0.38) : Color.yaleBlue
    }
    
    private var backgroundColor: Color {
        actionType.isDisabled ? Color.tangaGray : Color.yaleBlue
    }
    
    private func checkProtectedAction() {
        guard let summarId = summary.id else {
            return
        }
        guard let subscriptionAction = actionType.toSubscriptionAction(summaryId: summarId) else {
            return
        }
        
        Task {
            let action = ProtectedAction.subscription(subscriptionAction)
            let result = await protectedActionInteractor.checkProtectedAction(action)
            
            await MainActor.run {
                handleActionResult(result)
            }
        }
    }
    
    private func handleActionResult(_ result: ProtectedActionCheckResult) {
        switch result {
        case .authRequired:
            showAuth = true
        case .subscriptionRequired:
            showSubscription = true
        case .allowed:
            if actionType == .listen {
                showAudioFormatSelection = true
            } else {
                // Navigate directly based on action type
                navigateToDestination()
            }
        }
    }
    
    // Navigate directly based on action type
    private func navigateToDestination() {
        print("⏩ Navigating to destination for action: \(actionType)")
        
        switch actionType {
        case .read:
            navigateToReadSummary = true
            
        case .listen:
            // This case is handled by the format selection sheet
            break
            
        case .graphic:
            navigateToRichInsights = true
        }
    }
}


// Navigation helper extension
extension View {
    func debugPrint(_ message: String) -> Self {
        print(message)
        return self
    }
}

enum ActionType: CaseIterable {
    case read
    case listen
    case graphic

    var icon: String {
        switch self {
        case .read:
            return "o_read"
        case .listen:
            return "o_listen"
        case .graphic:
            return "o_mindmap"
        }
    }

    var title: String {
        switch self {
        case .read:
            return "Read"
        case .listen:
            return "Listen"
        case .graphic:
            return "Visualize"
        }
    }

    var isDisabled: Bool {
        switch self {
        case .read, .listen:
            return false
        case .graphic:
            return false
        }
    }
    
    func toSubscriptionAction(summaryId: SummaryId) -> ProtectedAction.SubscriptionRequiredAction? {
        switch self {
        case .read:
            return .read(summaryId: summaryId)
        case .listen:
            return .listen(summaryId: summaryId)
        case .graphic:
            return .listen(summaryId: summaryId)  // TODO to be changed
        }
    }
}

#if DEBUG
#Preview {
    ActionButton(actionType: ActionType.read, summary: dummySummaries[0], protectedActionInteractor: ProtectedActionInteractor(
        sessionManager: SessionManager(),
        revenuecatController: RevenueCatController()
    ))
}
#endif
