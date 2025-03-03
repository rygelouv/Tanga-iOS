//
//  SearchView.swift
//  Tanga
//
//  Created by Rygel Louv on 12/10/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery: String = ""
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        let summaries: [Summary]? = viewModel.summaries
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    CategoriesSectionView() { categoryId in
                        Task { await viewModel.toggleCategorySelection(category: categoryId) }
                    }
                    
                    let filteredSummaries = summaries?.filter { summary in
                        searchQuery.isEmpty || summary.title?.localizedCaseInsensitiveContains(searchQuery) == true
                        || summary.author?.localizedCaseInsensitiveContains(searchQuery) == true
                    }
                    
                    if filteredSummaries?.isEmpty == true {
                        SearchEmptyResultView(query: searchQuery)
                    } else {
                        SummaryGrid(summaries: filteredSummaries)
                    }
                }.navigationTitle("Explore")
            }
            .searchable(
                text: $searchQuery,
                placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always),
                prompt: "Book title, author name"
            )
            .task {
                await viewModel.loadAllSummaries()
            }
            .onChange(of: searchQuery) { oldValue, newValue in
                if newValue.count >= 4 {
                    AnalyticsTracker.shared.track(event: Events.actionSearch(query: newValue))
                }
            }
        }.background(Color.cultured)
    }
    
    struct CategoriesSectionView: View {
        var onCategorySelection: (CategoryId) -> Void
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Categories")
                    .fontWeight(.bold)
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .title2))
                    .foregroundColor(.navy)
                    .padding(.top, 10)
                    .padding(.leading, 14)
                FlowLayout(PredefinedCategory.allCases) { category in
                    CategoryTagView(
                        categoryName: category.categoryName,
                        categoryId: category.id,
                        icon: category.icon
                    ) { categoryId in
                        onCategorySelection(categoryId)
                        AnalyticsTracker.shared.track(event: Events.tapCategoryItemInSearch(categoryId: categoryId))
                    }
                }.padding(.horizontal, 10)
            }
        }
    }
}

private struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#if DEBUG
#Preview {
    let viewModel = SearchViewModel(summaries: dummySummaries)
    SearchView(viewModel: viewModel)
}
#endif
