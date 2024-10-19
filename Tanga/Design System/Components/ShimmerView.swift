//
//  ShimmerView.swift
//  Tanga
//
//  Created by Rygel Louv on 12/10/2024.
//

import SwiftUI

struct SummaryGridShimmerAnimation: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(0..<3) { _ in
                SummaryShimmerView(size: .large)
                SummaryShimmerView(size: .large)
            }
        }
    }
}

struct SummaryRowShimmerAnimation: View {
    var body: some View {
        VStack {
            ForEach(0..<3) { _ in
                HStack {
                    SummaryShimmerView()
                    SummaryShimmerView()
                    SummaryShimmerView()
                }
            }
        }
    }
}

struct SummaryShimmerView: View {
    var size: SummaryItemSize = .small
    
    var body: some View {
        let width = switch size {
            case .small: 120
            case .large: 170
        }
        let height = switch size {
            case .small:  150
            case .large: 200
        }
        VStack(alignment: .leading) {
            ShimmerView().frame(width: CGFloat(width), height: CGFloat(height)).clipShape(RoundedRectangle(cornerRadius: 10))
            ShimmerView().frame(width: CGFloat(width), height: 10).clipShape(RoundedRectangle(cornerRadius: 10))
            ShimmerView().frame(width: 60, height: 10).clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct ShimmerView: View {
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
        @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)
        
        private var gradientColors = [Color.gray.opacity(0.2), Color.white.opacity(0.2), Color.gray.opacity(0.2)]
        
    
    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                            startPoint = .init(x: 1, y: 1)
                            endPoint = .init(x: 2.2, y: 2.2)
                        }
                    }
    }
}

#Preview {
    ShimmerView()
}

#Preview {
    SummaryRowShimmerAnimation()
}

#Preview {
    SummaryGridShimmerAnimation()
}

