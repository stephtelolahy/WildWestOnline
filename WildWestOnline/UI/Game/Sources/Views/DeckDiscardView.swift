//
//  DeckDiscardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

import SwiftUI
import GameCore

// A view that displays the deck and discard piles in the center.
struct DeckDiscardView: View {
    let topDiscard: String?

    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Text("Deck")
                    .font(.headline)
                Image("card_back", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .cornerRadius(4)
                    .shadow(color: .black, radius: 2)
            }
            VStack {
                Text("Discard")
                    .font(.headline)
                if let topDiscard {
                    Image(Card.extractName(from: topDiscard), bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .cornerRadius(4)
                        .shadow(color: .black, radius: 2)
                }
            }
        }
    }
}

#Preview {
    DeckDiscardView(
        topDiscard: "bang-A♠️"
    )
}
