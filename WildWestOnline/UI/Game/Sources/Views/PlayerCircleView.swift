//
//  PlayerCircleView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

import SwiftUI

// Arranges players in an oval layout with the current player (first in the array) at the bottom.
// The deck/discard view is placed at the center.
struct PlayerCircleView: View {
    let players: [GameView.State.PlayerItem]
    let topDiscard: String?

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height
            // Compute horizontal and vertical radii for an oval layout.
            let horizontalRadius = availableWidth * 0.4
            let verticalRadius = availableHeight * 0.35
            let center = CGPoint(x: availableWidth / 2, y: availableHeight / 2)
            let count = players.count

            ZStack {
                // Place deck and discard view at the center.
                DeckDiscardView()
                    .position(x: center.x, y: center.y)

                // Arrange players along an ellipse.
                ForEach(players.indices, id: \.self) { i in
                    // Use the same angle offset so that the current player (index 0) is at the bottom (π/2 radians)
                    let angle = (2 * .pi / CGFloat(count)) * CGFloat(i) + (.pi / 2)

                    PlayerView(player: players[i])
                        .position(x: center.x + horizontalRadius * cos(angle),
                                  y: center.y + verticalRadius * sin(angle))
                }
            }
        }
    }
}
