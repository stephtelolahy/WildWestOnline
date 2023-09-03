//
//  GameState+Updating.swift
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

    /// Getting distance between players
    /// The distance between two players is the minimum number of places between them,
    /// counting clockwise or counterclockwise.
    /// When a character is eliminated, he is no longer counted when evaluating the distance:
    /// some players will get "closer" when someone is eliminated.
    func playersAt(_ range: Int, from player: String) -> [String] {
        playOrder
            .filter { $0 != player }
            .filter { distance(from: player, to: $0) <= range }
    }

    private func distance(from player: String, to other: String) -> Int {
        guard let pIndex = playOrder.firstIndex(of: player),
              let oIndex = playOrder.firstIndex(of: other),
              pIndex != oIndex else {
            return 0
        }

        let pCount = playOrder.count
        let rightDistance = (oIndex > pIndex) ? (oIndex - pIndex) : (oIndex + pCount - pIndex)
        let leftDistance = (pIndex > oIndex) ? (pIndex - oIndex) : (pIndex + pCount - oIndex)
        var distance = min(rightDistance, leftDistance)

        let scope = self.player(player).attributes[.scope] ?? 0
        distance -= scope

        let mustang = self.player(other).attributes[.mustang] ?? 0
        distance += mustang

        return distance
    }
}
