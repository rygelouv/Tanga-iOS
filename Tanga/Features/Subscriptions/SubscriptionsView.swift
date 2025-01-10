//
//  SubscriptionsView.swift
//  Tanga
//
//  Created by Rygel Louv on 07/01/2025.
//

import SwiftUI

struct SubscriptionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let offers = [
        "Unlimited Access to Summaries",
        "Unlimited Access to Audios",
        "AI Features* (Coming Soon)"
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(Color.white)
                            .frame(width: 38, height: 38)
                    }
                    .background(Color.white.opacity(0.2))
                    .clipShape(
                            Circle()
                        )
                    .frame(width: 48, height: 48)
                }.padding(.horizontal, 12)
                
            
                Image("pricing")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 68)
                    .padding(.top, 18)
                // Color.clear.frame(height: 0.5)
                
                Text("Upgrade to Premium and get the best of Tanga")
                    .fontWeight(.semibold)
                    .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach (offers, id: \.self) { offer in
                        OfferItemView(text: offer)
                            .padding(.bottom, 16)
                    }
                }
                
                Spacer(minLength: 30)
                
                ZStack(alignment: .top) {
                    VStack {
                        SubscriptionItemView(
                            text: "Yearly",
                            price: "$40.99",
                            cadence: "Year",
                            isSelected: false,
                            shouldGlow: true
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 14)
                        SubscriptionItemView(
                            text: "Montly",
                            price: "$3.99",
                            cadence: "Year",
                            isSelected: true,
                            shouldGlow: false
                        ).padding(.horizontal, 20)
                    }.padding(.top, 16)
                    
                    BestValueView()
                 }
                Text("Restore purchase")
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(
                gradient: Gradient(colors: [.cerulean, .yaleBlue, .navy]),
                startPoint: .top,
                endPoint: .bottom
            ))
    }
    
    struct OfferItemView: View {
        let text: String
        
        
        var body: some View {
            HStack(spacing: 10) {
                Image("check")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Text(text)
                    .font(Font.custom("Montserrat", size: 13, relativeTo: .body))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
            }
        }
    }
    
    struct SubscriptionItemView: View {
        let text: String
        let price: String
        let cadence: String
        let isSelected: Bool
        let shouldGlow: Bool
        
        var body: some View {
            ZStack {
                if shouldGlow {
                    RoundedRectangle(cornerRadius: 6)
                        .animatedGlow(lineWidth: 2.0, duration: 1.0)
                } else {
                    RoundedRectangle(cornerRadius: 6).stroke(Color.cerulean, lineWidth: 1)
                }
                
                HStack {
                    Text(text)
                        .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .orange : .white)
                    Spacer()
                    SubscriptionPriceView(price: price, cadence: cadence, isSelected: isSelected)
                }.padding()
                    .background(Color.navy)
                    .cornerRadius(6)
            }
        }
    }
    
    struct SubscriptionPriceView: View {
        let price: String
        let cadence: String
        let isSelected: Bool
        
        var body: some View {
            HStack {
                Text(price)
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                    .fontWeight(.bold)
                    .foregroundColor(.cerulean)
                Text("/ "+"\(cadence)")
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                if isSelected {
                    Image("checked")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    struct BestValueView: View {
        
        var body: some View {
            Text("Best Value")
                .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.cerulean)
                .cornerRadius(6)
        }
    }
}

#Preview {
    SubscriptionsView()
}
