//
//  CategorySummariesView.swift.swift
//  Tanga
//
//  Created by Rygel Louv on 10/10/2024.
//

import SwiftUI

struct CategorySummariesView: View {
    var categoryId: CategoryId
    @StateObject var viewModel: CategorySummariesViewModel
    
    init(categoryId: CategoryId) {
        self.categoryId = categoryId
        _viewModel = StateObject(wrappedValue: CategorySummariesViewModel(categoryId: categoryId))
    }
    
    var body: some View {
        let summaries: [Summary]? = viewModel.summaries
        let category: PredefinedCategory? = viewModel.category
        
        ZStack {
            if viewModel.isLoading {
                SummaryGridShimmerAnimation()
                    .padding(.vertical, 30)
            } else {
                ScrollView {
                    VStack {
                        if let category = category {
                            CategoryHeaderView(
                                topics: category.topics,
                                illustration: category.illustration
                            ).padding(.horizontal, 8)
                        }
                        SummaryGrid(summaries: summaries)
                        TangaButton(onButtonTap: {}, leftIcon: "search", text: "Explore Summaries").padding()
                    }.padding(.horizontal, 2)
                }
                .navigationTitle(category?.categoryName ?? "")
            }
        }.onAppear {
            viewModel.load()
        }
    }
    
    struct CategoryHeaderView: View {
        var topics: String
        var illustration: String
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.silverFoil.opacity(0.2))
                    .stroke(Color.silverFoil.opacity(0.3), lineWidth: 1)
                
                HStack() {
                    Image(illustration)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    Spacer()
                    Text(topics)
                        .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.auroMetalSaurus)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
            }.padding(.horizontal, 6)
        }
    }
}

#Preview {
    CategorySummariesView(categoryId: PredefinedCategory.businessCareer.id)
}
