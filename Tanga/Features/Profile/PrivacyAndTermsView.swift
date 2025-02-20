//
//  PrivacyAndTermsView.swift
//  Tanga
//
//  Created by Rygel Louv on 20/02/2025.
//

import SwiftUI

let privacyPolicyURL = "https://tanga.app/privacy_policy.html"
let termsAndConditionsURL = "https://tanga.app/terms_and_conditions.html"

struct PrivacyAndTermsView: View {
    @Environment(\.openURL) var openLink
    
    var body: some View {
        ZStack {
            VStack {
                ProfileContentAction(
                    imageName: "privacy",
                    text: "Privacy Policy",
                    color: .green,
                    paddingValue: 12,
                    onClick: { openLink(URL(string: privacyPolicyURL)!) }
                )
                .background(Color.white)
                
                ProfileContentAction(
                    imageName: "terms",
                    text: "Terms and Conditions",
                    color: .yellow,
                    paddingValue: 12,
                    onClick: { openLink(URL(string: termsAndConditionsURL)!) }
                )
                .background(Color.white)
                
                Spacer()
            }
        }.background(Color.cultured)
    }
}

#Preview {
    PrivacyAndTermsView()
}
