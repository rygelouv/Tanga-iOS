//
//  Summary.swift
//  Tanga
//
//  Created by Rygel Louv on 06/10/2024.
//

import SwiftUI

enum SummaryItemSize {
    case small
    case large
}

struct SummaryItemView: View {
    var summary: Summary?
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
            SummaryImageView(url: summary?.coverImageUrl ?? "")
                .padding(.leading, 2)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .padding(.trailing, 3)
            Text(summary?.title ?? "")
                .fontWeight(.semibold)
                .font(Font.custom("Montserrat", size: CGFloat(textSize), relativeTo: .title2))
                .foregroundColor(.navy)
                .lineLimit(1)
                .truncationMode(.tail)
            Text(summary?.author ?? "")
                .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                .fontWeight(.regular)
                .foregroundStyle(Color.auroMetalSaurus)
                .lineLimit(1)
                .truncationMode(.tail)
            SummaryIndicators(duration: summary?.playingLength)
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

#Preview {
    SummaryItemView(size: .large)
}
