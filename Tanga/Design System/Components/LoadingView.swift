//
//  LoadingView.swift
//  Tanga
//
//  Created by Rygel Louv on 28/02/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4) // Semi-transparent background
                .ignoresSafeArea()
                .onTapGesture {} // Prevent taps from passing through

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .allowsHitTesting(true) // Ensures interaction is blocked
    }
}

#Preview {
    LoadingView()
}
