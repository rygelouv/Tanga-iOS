//
//  NotificationView.swift
//  Tanga
//
//  Created by Rygel Louv on 29/01/2025.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notificationManager: NotificationPermissionManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                CloseButtonView(dismiss: { dismiss() }, variation: .tertiary).padding(.top, 16)
                
                // This should probably move to design system - checkout similar headline in SubscriptionView
                Text("Enable notifications to enjoy the best of Tanga!")
                    .fontWeight(.bold)
                    .font(Font.custom("Montserrat", size: 22, relativeTo: .title))
                    .foregroundColor(.navy)
                    .multilineTextAlignment(.center)
                    .padding(.top, 14)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 12)
                
                NotificationImage()
                
                Spacer()
                
                FeaturesView()
                
                Spacer(minLength: 28)
                
                TangaButton(
                    onButtonTap: {
                        Task {
                            await notificationManager.request()
                        }
                    },
                    text: "Allow Notifications",
                    size: .small,
                    variation: .secondary
                ).padding(.horizontal, 16)
                
                Spacer()
                
                TangaButton(
                    onButtonTap: {
                        dismiss()
                    },
                    text: "Not Now",
                    size: .small,
                    variation: .tertiary
                ).padding(.horizontal, 16)
            }.padding(.horizontal, 18)
        }
        .background(Color.cultured)
        .onChange(of: notificationManager.hasPermission) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    struct NotificationImage: View {
        var body: some View {
            Image("graphic_push_notifications_blue")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 48)
        }
    }
    
    struct FeaturesView : View {
        var body: some View {
            VStack( alignment: .leading, spacing: 24) {
                NotificationFeatureItemView(
                    text: "We will let you when a new free weekly summary is available",
                    icon: "schedule"
                )
                
                NotificationFeatureItemView(
                    text: "We notify you when new summaries are available",
                    icon: "new-summary"
                )
                
                NotificationFeatureItemView(
                    text: "We will send you alerts when we have discounts on subscriptions",
                    icon: "subscription"
                )
            }
        }
    }
    
    struct NotificationFeatureItemView: View {
        let text: String
        let icon: String
        
        var body: some View {
            HStack {
                HStack(spacing: 10) {
                    Image(icon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.yaleBlue)
                    
                    Text(text)
                        .font(Font.custom("Montserrat", size: 14, relativeTo: .body))
                        .fontWeight(.bold)
                        .foregroundColor(.auroMetalSaurus)
                }
            }
        }
    }
}

#Preview {
    NotificationView()
}
