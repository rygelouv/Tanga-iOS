//
//  LibraryView.swift
//  Tanga
//
//  Created by Rygel Louv on 10/10/2024.
//

import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel: LibraryViewModel = LibraryViewModel(favoriteRepository: FavoriteRepository())
    
    var body: some View {
        ZStack {
            if viewModel.favorites != nil && !viewModel.favorites!.isEmpty {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Library")
                            .fontWeight(.bold)
                            .font(Font.custom("Montserrat", size: 28, relativeTo: .title))
                            .foregroundColor(.navy).padding()
                        
                        FavoriteGrid(favorites: viewModel.favorites)
                    }
                }
            } else {
                LibraryEmptyView().frame(maxHeight: .infinity)
            }
        }.onAppear {
            viewModel.loadFavorites()
        }
    }
    
    struct FavoriteGrid: View {
        var favorites: [Favorite]?
        
        var body: some View {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                if let favorites {
                   ForEach(favorites) { favorite in
                       FavoriteItemView(favorite: favorite, size: .large)
                    }
                }
            }
        }
    }
    
    struct FavoriteItemView: View {
        var favorite: Favorite?
        var size: SummaryItemSize = .small
        
        var body: some View {
            let width = switch size {
                case .small: 120
                case .large: 170
            }
            let textSize = switch size {
                case .small: 14
                case .large: 16
            }
            VStack(alignment: .leading) {
                SummaryImageView(url: favorite?.coverUrl ?? "")
                    .padding(.leading, 2)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .padding(.trailing, 3)
                Text(favorite?.title ?? "")
                    .fontWeight(.semibold)
                    .font(Font.custom("Montserrat", size: CGFloat(textSize), relativeTo: .title2))
                    .foregroundColor(.navy)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(favorite?.author ?? "")
                    .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.auroMetalSaurus)
                    .lineLimit(1)
                    .truncationMode(.tail)
                SummaryIndicators(duration: favorite?.playingLength)
            }.frame(width: CGFloat(width))
        }
        
        struct SummaryIndicators: View {
            var duration: String?
            
            var body: some View {
                HStack {
                    Image("o_listen")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("\(duration ?? "00:00") min")
                        .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.yaleBlue)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
