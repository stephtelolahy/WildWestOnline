//
//  BoardCardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 16/03/2025.
//

import SwiftUI
import GameCore

// A view that displays the deck or discard card
struct BoardCardView: View {
    let content: CardContent

    var cardName: String {
        switch content {
        case .id(let id):
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
    BoardCardView(
        content: .id("bang-A♠️")
    )
}
