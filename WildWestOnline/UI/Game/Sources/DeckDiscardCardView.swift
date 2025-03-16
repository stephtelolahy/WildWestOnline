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
    let content: Content

    enum Content {
        case card(String)
        case back
        case empty
    }

    var cardName: String {
        switch content {
        case .card(let id):
            Card.extractName(from: id)
        case .back:
            "card_back"
        case .empty:
            ""
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
        content: .card("bang-A♠️")
    )
}
