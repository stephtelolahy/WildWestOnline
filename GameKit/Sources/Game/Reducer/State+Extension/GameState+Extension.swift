//
//  GameState+Extension.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

extension GameState {
    /// Draw the top card from the deck
    /// As soon as the draw pile is empty, shuffle the discard pile to create a new playing deck.
    mutating func popDeck() throws -> String {
        if deck.cards.isEmpty {
            guard discard.count >= 2 else {
                throw GameError.deckIsEmpty
            }

            let cards = discard.cards
            discard = CardStack(cards: Array(cards.prefix(1)))
            deck = CardStack(cards: Array(cards.dropFirst()).shuffled())
        }

        return deck.pop()
    }

    mutating func incrementPlayedThisTurn(for cardName: String) {
        playedThisTurn[cardName] = (playedThisTurn[cardName] ?? 0) + 1
    }
}
