//
//  LazyView.swift
//  Tanga
//
//  Created by Rygel Louv on 14/05/2025.
//

import SwiftUI

/// A view that lazily creates its content only when needed
struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @escaping () -> Content) {
        self.build = build
    }
    
    var body: some View {
        build()
    }
}
