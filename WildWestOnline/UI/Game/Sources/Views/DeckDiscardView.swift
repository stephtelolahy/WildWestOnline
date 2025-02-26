//
//  DeckDiscardView.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

import SwiftUI

// A view that displays the deck and discard piles in the center.
struct DeckDiscardView: View {
    var body: some View {
        HStack(spacing: 24) {
            VStack {
                Text("Deck")
                    .font(.headline)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green)
                    .frame(width: 60, height: 90)
            }
            VStack {
                Text("Discard")
                    .font(.headline)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red)
                    .frame(width: 60, height: 90)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    DeckDiscardView()
}
