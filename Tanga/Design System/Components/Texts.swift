//
//  Texts.swift
//  Tanga
//
//  Created by Rygel Louv on 08/12/2024.
//

import SwiftUI

struct ExpandableText: View {
    let text: String
    @State private var isExpanded = false
    let minLength = 100 // Number of characters to show initially
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(displayText)
                .foregroundColor(.auroMetalSaurus)
                .font(Font.custom("Montserrat", size: 16, relativeTo: .title))
                .padding(.bottom, 10)
            
            if text.count > minLength {
                Button(action: {
                    isExpanded.toggle()
                }) {
                    HStack(alignment: .center) {
                        Text(isExpanded ? "Show less" : "Show more")
                            .font(Font.custom("Montserrat", size: 16, relativeTo: .title))
                            .foregroundColor(Color.yaleBlue).frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var displayText: String {
        if text.count <= minLength || isExpanded {
            return text
        }
        return text.prefix(minLength) + "..."
    }
}

#Preview {
    ExpandableText(text: "Rework by Jason Fried and David Heinemeier Hansson is a revolutionary guide to entrepreneurship and business. The book challenges traditional notions of how to run a successful business and provides unconventional wisdom for creating and sustaining a profitable venture.")
}
