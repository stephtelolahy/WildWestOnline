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
                        .stroke(card.active ? Color.green : Color.gray,
                                lineWidth: card.active ? 4 : 1)
                )
                .shadow(radius: 2)

            // Card image (replace with your own asset if available)
            Image(Card.extractName(from: card.card), bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            VStack {
                Spacer()
                HStack {
                    Text(Card.extractValue(from: card.card))
                        .font(.headline)
                        .padding([.leading, .bottom], 8)
                    Spacer()
                }
            }

        }
        .frame(width: 96 + 8, height: 150 + 8)
    }
}

#Preview {
    HandCardView(
        card: .init(
            card: "mustang-8♥️",
            active: true
        )
    )
}
