//
//  SummaryListView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
// - Dalle (400k)
// - Enduis (300k)
// - Electricité (1M)
// - Plafond (1M)
// - Portes + Fenêtres (600k)
// - Carreaux (700k)


import SwiftUI

struct SummaryRowView: View {
    var summaries: [Summary]?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                if let summaries {
                    ForEach(summaries) { summary in
                        SummaryItemView(summary: summary)
                    }
                }
            }
        }
    }
}

struct SummaryGrid: View {
    var summaries: [Summary]?
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            if let summaries {
               ForEach(summaries) { summary in
                    SummaryItemView(summary: summary, size: .large)
                }
            }
        }
    }
}

#Preview {
    SummaryRowView(summaries: dummySummaries)
}

#Preview {
    SummaryGrid(summaries: dummySummaries)
}
