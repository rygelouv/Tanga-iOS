//
//  View+Extensions.swift
//  Tanga
//
//  Created by Rygel Louv on 25/02/2025.
//

import SwiftUI

// MARK: - View Extension for Tap Tracking

extension View {
    /**
     A convenience modifier that adds tap gesture tracking with simpler syntax.
     
     This modifier wraps the more verbose `simultaneousGesture` with `TapGesture`
     to provide a cleaner API for handling tap events.
     
     - Parameter action: The closure to execute when the view is tapped
     - Returns: A view with the tap gesture applied
     
     Example usage:
     ```swift
     Button("Search") { /* button action */ }
         .onTap {
             AnalyticsTracker.shared.track(event: Events.tapSearch)
             TangaLogger.shared.debug("Search button tapped")
         }
     ```
     */
    func onTap(perform action: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                action()
            }
        )
    }
    
    /**
     Tracks a tap event in analytics when the view is tapped.
     
     This is a specialized version of `onTap` that automatically tracks
     a specified analytics event when the view is tapped.
     
     - Parameters:
        - event: The analytics event to track
        - additionalAction: Optional additional action to perform when tapped
     - Returns: A view with tap tracking applied
     
     Example usage:
     ```swift
     SearchButton()
         .trackTap(event: Events.tapSearch) {
             // Optional additional actions
             TangaLogger.shared.debug("Search button tapped")
         }
     ```
     */
    func trackTap(event: AnalyticsEvent, additionalAction: (() -> Void)? = nil) -> some View {
        self.onTap {
            AnalyticsTracker.shared.track(event: event)
            additionalAction?()
        }
    }
}
