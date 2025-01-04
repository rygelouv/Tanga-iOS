//
//  SummaryActionButton.swift
//  Tanga
//
//  Created by Rygel Louv on 03/01/2025.
//

import SwiftUI

struct ActionButton: View {
    let actionType: ActionType
    let summaryId: SummaryId

    var body: some View {
        NavigationLink(destination: ReadSummaryView(summaryId: summaryId)) {
            VStack(spacing: 0){
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
    }
    
    private var textColor: Color {
        actionType.isDisabled ? Color.tangaGray.opacity(0.38) : Color.yaleBlue
    }
    
    private var backgroundColor: Color {
        actionType.isDisabled ? Color.tangaGray : Color.yaleBlue
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
            return true
        }
    }
}

#Preview {
    ActionButton(actionType: ActionType.read, summaryId: SummaryId("1234"))
}
