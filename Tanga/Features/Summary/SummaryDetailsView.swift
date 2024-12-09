//
//  SummaryDetailsView.swift
//  Tanga
//
//  Created by Rygel Louv on 08/12/2024.
//

import SwiftUI

struct SummaryDetailsView: View {
    let summaryId: SummaryId
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    SummaryHeader()
                    Spacer()
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Introduction")
                            .fontWeight(.bold)
                            .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                            .foregroundColor(Color.navy)
                            .padding(.top, 8)
                        ExpandableText(text: "Rework by Jason Fried and David Heinemeier Hansson is a revolutionary guide to entrepreneurship and business. The book challenges traditional notions of how to run a successful business and provides unconventional wisdom for creating and sustaining a profitable venture.")
                    }.padding()
                    Spacer()
                    RecommendationSection(summaries: dummySummaries)
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Another action
                    }) {
                        Image("bookmark")
                            .resizable()
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color.silverFoil)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Your share action here
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .frame(width: 20, height: 28)
                            .foregroundColor(Color.silverFoil)
                    }
                }
            }.toolbarBackground(Color.white, for: .navigationBar)
        }
    }
    
    struct SummaryHeader: View {
        var body: some View {
            VStack() {
                // Header section
                VStack(alignment: .leading, spacing: 16) {
                    // Book cover and title section
                    HStack(alignment: .top, spacing: 30) {
                        // Book cover
                        Image("placeholder_image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        // Title and duration section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Rework")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 24, relativeTo: .title))
                                .foregroundColor(Color.navy)
                            
                            Text("Jason Fried & David Heinemeier Hansson")
                                .fontWeight(.bold)
                                .font(Font.custom("Montserrat", size: 16, relativeTo: .title2))
                                .foregroundStyle(Color.auroMetalSaurus)
                            
                            HStack {
                                Image(systemName: "headphones")
                                    .foregroundColor(.yaleBlue)
                                Text("18:19 min")
                                    .fontWeight(.semibold)
                                    .font(Font.custom("Montserrat", size: 14, relativeTo: .title))
                                    .foregroundColor(Color.yaleBlue)
                            }
                        }
                    }
                }
                .padding()
                
                // Action buttons
                HStack(spacing: 30) {
                    ActionButton(icon: "o_read", title: "Read", isDisabled: false)
                    ActionButton(icon: "o_listen", title: "Listen", isDisabled: false)
                    ActionButton(icon: "o_mindmap", title: "Visualize", isDisabled: true)
                }
                .padding()
            }
            .background(Color.white)
                .clipShape(
                    RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 40)
                )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }

    struct ActionButton: View {
        let icon: String
        let title: String
        let isDisabled: Bool
        
        var body: some View {
            VStack {
                Image(icon)
                    .renderingMode(.template)
                    .font(.system(size: 24))
                    .foregroundColor(textColor)
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
                    
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
                    .padding(.bottom, 14)
                
            }
            .background(backgroundColor.opacity(0.1))
                .cornerRadius(12)
        }
        
        private var textColor: Color {
            isDisabled ? Color.tangaGray.opacity(0.38) : Color.yaleBlue
        }
        
        private var backgroundColor: Color {
            isDisabled ? Color.tangaGray : Color.yaleBlue
        }
    }
    
    struct RecommendationSection: View {
        var summaries: [Summary]?
        
        var body: some View {
            VStack {
                HStack {
                    Text("Recommended summaries")
                        .fontWeight(.bold)
                        .font(Font.custom("Montserrat", size: 18, relativeTo: .title))
                        .foregroundColor(.navy)
                    Spacer()
                }
                
                SummaryRowView(summaries: summaries ?? [])
            }.padding()
        }
    }
}

#Preview {
    SummaryDetailsView(summaryId: .init("1"))
}
