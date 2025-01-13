//
//  SubscriptionsView.swift
//  Tanga
//
//  Created by Rygel Louv on 07/01/2025.
//

import SwiftUI
import RevenueCat

struct SubscriptionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = SubscriptionsViewModel(
        revenueCatController: RevenueCatController()
    )
    
    let offers = [
        "Unlimited Access to Summaries",
        "Unlimited Access to Audios",
        "AI Features* (Coming Soon)",
        "Cancel Anytime"
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                
                CloseButtonView(dismiss: { dismiss() })
                
                Image("pricing")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 68)
                    .padding(.top, 18)
                
                Text("Upgrade to Premium and get the best of Tanga")
                    .fontWeight(.semibold)
                    .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 14)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach (offers, id: \.self) { offer in
                        OfferItemView(text: offer)
                            .padding(.bottom, 16)
                    }
                }
                
                Spacer(minLength: 30)
                
                if let subscriptions = viewModel.subscriptions {
                    SubscriptionsView(
                        subscriptions: subscriptions,
                        selectedPackage: viewModel.selectedPackage,
                        onMakePurchase: viewModel.onMakePurchase(subscriptionPackage:),
                        getSubscriptionCadence: viewModel.getSubscriptionCadence(subscriptionPackage:)
                    )
                }
                
                Text("Restore purchase")
                    .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(
            gradient: Gradient(colors: [.cerulean, .yaleBlue, .navy]),
            startPoint: .top,
            endPoint: .bottom
        ))
        .onAppear {
            viewModel.getSubscriptions()
        }
        .onChange(of: viewModel.closeSubscriptionScreen, initial: false) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    struct CloseButtonView: View {
        let dismiss: () -> Void

        var body: some View {
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
                .clipShape(Circle())
                .frame(width: 48, height: 48)
            }
            .padding(.horizontal, 12)
        }
    }
    
    struct SubscriptionsView: View {
        let subscriptions: [SubscriptionPackage]
        let selectedPackage: SubscriptionPackage?
        let onMakePurchase: (SubscriptionPackage) -> Void
        let getSubscriptionCadence: (SubscriptionPackage) -> String

        var body: some View {
            ZStack(alignment: .top) {
                VStack {
                    ForEach(subscriptions) { subscription in
                        SubscriptionItemView(
                            text: subscription.title,
                            price: subscription.price.amount,
                            cadence: getSubscriptionCadence(subscription),
                            isSelected: subscription.id == selectedPackage?.id,
                            shouldGlow: subscription.type == .yearly
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 14)
                        .onTapGesture {
                            onMakePurchase(subscription)
                        }
                    }
                }
                .padding(.top, 16)
                
                BestValueView()
            }
        }
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
                    if isSelected {
                        Spacer()
                        ProgressView().tint(.white)
                    }
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
                    .font(Font.custom("Montserrat", size: 13, relativeTo: .body))
                    .fontWeight(.semibold)
                    .foregroundColor(.cerulean)
                Text("/ "+"\(cadence)")
                    .font(Font.custom("Montserrat", size: 13, relativeTo: .body))
                    .fontWeight(.regular)
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
                .font(Font.custom("Montserrat", size: 12, relativeTo: .body))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(Color.cerulean)
                .cornerRadius(6)
        }
    }
}

#Preview {
    SubscriptionsView()
}
