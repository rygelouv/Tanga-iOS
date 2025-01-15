//
//  GlowAnimation.swift
//  Tanga
//
//  Created by Rygel Louv on 08/01/2025.
//

import SwiftUI

/// Extension that adds a glow effect to any Shape
extension View where Self: Shape {
    /// Applies a glow effect to a shape using multiple layered strokes and blur effects
    /// - Parameters:
    ///   - fill: The style to fill the shape with (e.g., color, gradient)
    ///   - lineWidth: The width of the stroke lines
    ///   - blurRadius: The amount of blur to apply to the glow effect (default: 8.0)
    ///   - lineCap: The style of the line endings (default: .round)
    /// - Returns: A view with the glow effect applied
    func glow(
        fill: some ShapeStyle,
        lineWidth: Double,
        blurRadius: Double = 8.0,
        lineCap: CGLineCap = .round
    ) -> some View {
        self
            // Base layer: Thin stroke
            .stroke(style: StrokeStyle(lineWidth: lineWidth / 2, lineCap: lineCap))
            .fill(fill)
            .overlay {
                // Middle layer: Full width stroke with maximum blur
                self
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                    .fill(fill)
                    .blur(radius: blurRadius)
            }
            .overlay {
                // Top layer: Full width stroke with reduced blur for intensity
                self
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                    .fill(fill)
                    .blur(radius: blurRadius / 2)
            }
    }
}

/// Extension to create animated gradient styles
extension ShapeStyle where Self == AngularGradient {
    /// Creates an angular gradient with predefined color stops that can be rotated
    /// - Parameter angle: The starting angle of the gradient rotation
    /// - Returns: An angular gradient that can be used as a ShapeStyle
    static func animatedPalette(angle: Angle) -> some ShapeStyle {
        .angularGradient(
            stops: [
                .init(color: .blue, location: 0.0),
                .init(color: .red, location: 0.4),
                .init(color: .green, location: 0.7),
                .init(color: .blue, location: 1.0),
            ],
            center: .center,
            startAngle: angle,
            endAngle: angle + .degrees(360)
        )
    }
}

/// Extension that combines the glow effect with continuous rotation animation
extension View where Self: Shape {
    /// Applies an animated glow effect to a shape
    /// - Parameters:
    ///   - lineWidth: The width of the stroke lines (default: 4.0)
    ///   - duration: The time for one complete rotation in seconds (default: 1.0)
    /// - Returns: A view with an animated glow effect
    func animatedGlow(
        lineWidth: Double = 4.0,
        duration: Double = 1.0
    ) -> some View {
        TimelineView(.animation) { timeline in
            // Calculate progress based on current time
            let elapsedTime = timeline.date.timeIntervalSince1970
            // Normalize progress to create continuous rotation (0.0 to 1.0)
            let normalizedProgress = (elapsedTime.truncatingRemainder(dividingBy: duration) / duration)
            
            // Apply glow effect with rotating gradient
            self.glow(
                fill: .animatedPalette(angle: .degrees(360 * normalizedProgress)),
                lineWidth: lineWidth
            )
        }
    }
}

struct GlowView : View {
    @State private var rotation: Double = 0.0
  
  var body: some View {
      Rectangle()
          .animatedGlow(lineWidth: 2.0, duration: 1.0)
          .frame(width: 300, height: 80)
  }
}

#Preview {
    GlowView()
}
