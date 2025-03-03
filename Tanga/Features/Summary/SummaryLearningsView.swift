//
//  SummaryLearningsView.swift
//  Tanga
//
//  Created by Rygel Louv on 06/01/2025.
//

import SwiftUI

struct SummaryLearningsView: View {
    let keyLearnings: [String]
    
    var body : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6).stroke(Color.auroMetalSaurus.opacity(0.3), lineWidth: 1)
            VStack(alignment: .leading, spacing: 10) {
                Text("Key Ideas")
                    .fontWeight(.bold)
                    .font(Font.custom("Montserrat", size: 16, relativeTo: .title))
                    .foregroundColor(Color.navy)
                ForEach (keyLearnings, id: \.self) { keyLearning in
                    KeyLearningsItemView(text: keyLearning)
                }.padding(.vertical, 2)
            }.padding(14)
        }
    }
    
    struct KeyLearningsItemView: View {
        let text: String
        
        var body: some View {
            HStack {
                HStack(spacing: 10) {
                    Image("check")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.yaleBlue)
                    
                    Text(text)
                        .font(Font.custom("Montserrat", size: 13, relativeTo: .body))
                        .fontWeight(.regular)
                        .foregroundColor(.auroMetalSaurus)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    SummaryLearningsView(keyLearnings: dummySummaries[0].keyLearnings ?? [])
}
#endif
