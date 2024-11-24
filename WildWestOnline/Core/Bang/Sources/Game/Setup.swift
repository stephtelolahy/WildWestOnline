//
//  Setup.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

public enum Setup {
    public static func buildDeck(cardSets: [String: [String]]) -> [String] {
        var result: [String] = []
        for (key, values) in cardSets {
            for value in values {
                result.append("\(key)-\(value)")
            }
        }
        return result
    }

    public static func buildGame(
        figures: [String],
        deck: [String],
        cards: [String: Card]
    ) -> GameState {
        var deck = deck
        var players: [String: Player] = [:]

        for figure in figures {
            let id = figure
            let player = buildPlayer(figure: figure, cards: cards, deck: &deck)
            players[id] = player
        }

        return .init(
            players: players,
            cards: cards,
            deck: deck,
            discard: [],
            discovered: [],
            playOrder: figures,
            startOrder: figures,
            queue: [],
            playedThisTurn: [:],
            isOver: false
        )
    }
}

private extension Setup {
    static func buildPlayer(
        figure: String,
        cards: [String: Card],
        deck: inout [String]
    ) -> Player {
        guard let figureObj = cards[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        let health = 4
        let weapon = 1
        let magnifying = 0
        let remoteness = 0
        let handLimit = 0
        let abilities = [figure]

        let hand = Array(1...health).compactMap { _ in
            if deck.isNotEmpty {
                deck.removeFirst()
            } else {
                nil
            }
        }

        return .init(
            health: health,
            maxHealth: health,
            hand: hand,
            inPlay: [],
            magnifying: magnifying,
            remoteness: remoteness,
            weapon: weapon,
            abilities: abilities,
            handLimit: handLimit
        )
    }
}
