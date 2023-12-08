//
//  RadialView.swift
//  
//
//  Created by Hugues Telolahy on 08/12/2023.
//

import SwiftUI

struct RadialView: View {
    @State private var count = 7

    var body: some View {
        RadialLayout {
            ForEach(0..<count, id: \.self) { value in
                Text("\(value)")
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding()
                    .overlay(
                        Circle()
                        .stroke(Color.primary, lineWidth: 4)
                        .padding(6)
                    )
            }
        }
        .background(.green.gradient)
        .safeAreaInset(edge: .bottom) {
            Stepper("Count: \(count)", value: $count.animation(), in: 0...36)
                .padding()
        }
    }
}

#Preview {
    RadialView()
}

struct RadialLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        // accept the full proposed space, replacing any nil values with a sensible default
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        // calculate the radius of our bounds
        let radius = min(bounds.size.width, bounds.size.height) / 2

        // figure out the angle between each subview on our circle
        let angle = Angle.degrees(360 / Double(subviews.count)).radians

        for (index, subview) in subviews.enumerated() {
            // ask this view for its ideal size
            let viewSize = subview.sizeThatFits(.unspecified)

            // calculate the X and Y position so this view lies inside our circle's edge
            let xPos = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
            let yPos = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)

            // position this view relative to our centre, using its natural size ("unspecified")
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}
