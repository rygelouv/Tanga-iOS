import SwiftUI

struct InsightVideoPageView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Image(systemName: "play.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    InsightVideoPageView()
}
