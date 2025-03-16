//
//  DeckDiscardCardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

import SwiftUI
import GameCore

// A view that displays the deck or discard card
struct DeckDiscardCardView: View {
    let card: String?

    var cardName: String {
        if let card {
            Card.extractName(from: card)
        } else {
            "card_back"
        }
    }

    var body: some View {
        Image(cardName, bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .cornerRadius(4)
            .shadow(color: .black, radius: 2)
    }
}

#Preview {
    DeckDiscardCardView(
        card: "bang-A♠️"
    )
}
