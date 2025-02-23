//
//  HandCardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

import SwiftUI
import GameCore

// A custom view for each hand card displaying an image, a value, a suit, and an active state.
struct HandCardView: View {
    let card: GameView.State.HandCard

    var body: some View {
        ZStack {
            // Card background with rounded corners and a border that changes based on the active state.
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(card.active ? Color.blue : Color.gray,
                                lineWidth: card.active ? 3 : 1)
                )
                .shadow(radius: 2)

            VStack {
                // Card image (replace with your own asset if available)
                Image(Card.extractName(from: card.card), bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.top, 8)

                Spacer()

                // Display card value and suit at the bottom
                HStack(spacing: 4) {
                    Text(card.card)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 8)
            }
            .padding([.leading, .trailing], 8)
        }
        .frame(width: 100, height: 150)
    }
}

#Preview {
    HandCardView(
        card: .init(
            card: "mustang-2♥️",
            active: true
        )
    )
}
