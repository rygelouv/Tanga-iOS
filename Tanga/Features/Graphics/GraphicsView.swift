//
//  GraphicsView.swift
//  Tanga
//
//  Created by Rygel Louv on 05/01/2025.
//

import SwiftUI

struct GraphicsView: View {
    let summary: Summary
    
    var body: some View {
        Text("Sorry, Tanga Graphics is currently unavailable. Try again later")
    }
}

#if DEBUG
#Preview {
    GraphicsView(summary: dummySummaries[0])
}
#endif
