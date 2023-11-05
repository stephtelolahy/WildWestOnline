//
//  Setup.swift
//
//
//  Created by Hugues Telolahy on 19/05/2023.
//

public enum Setup {
    public static func buildGame(
        figures: [String],
        deck: [String],
        cardRef: [String: Card],
        defaultAttributes: [AttributeKey: Int] = [:],
        defaultAbilities: [String] = []
    ) -> GameState {
        var deck = deck.shuffled()
        let players: [Player] = figures.map {
            Self.buildPlayer(
                figureName: $0,
                deck: &deck,
                cardRef: cardRef,
                defaultAttributes: defaultAttributes,
                defaultAbilities: defaultAbilities
            )
        }

        var playerDictionary: [String: Player] = [:]
        var playOrder: [String] = []
        for player in players {
            playerDictionary[player.id] = player
            playOrder.append(player.id)
        }

        return GameState(
            players: playerDictionary,
            playOrder: playOrder,
            startOrder: playOrder,
            playedThisTurn: [:],
            deck: CardStack(cards: deck),
            discard: .init(cards: []),
            queue: [],
            cardRef: cardRef
        )
    }

    private static func buildPlayer(
        figureName: String,
        deck: inout [String],
        cardRef: [String: Card],
        defaultAttributes: [AttributeKey: Int],
        defaultAbilities: [String]
    ) -> Player {
        guard let figure = cardRef[figureName] else {
            fatalError("Missing figure named \(figureName)")
        }

        let attributes = defaultAttributes.merging(figure.attributes) { _, new in new }
        let abilities = defaultAbilities + [figureName]

        guard let health = attributes[.maxHealth] else {
            fatalError("missing attribute maxHealth")
        }

        let handCards: [String] = Array(1...health).map { _ in deck.removeFirst() }
        let hand = CardLocation(cards: handCards, hidden: true)

        return Player(
            id: figureName,
            name: figureName,
            abilities: abilities,
            startAttributes: attributes,
            attributes: attributes,
            health: health,
            hand: hand,
            inPlay: .init(cards: [])
        )
    }

    public static func buildDeck(cardSets: [String: [String]]) -> [String] {
        var result: [String] = []
        for (key, values) in cardSets {
            for value in values {
                result.append("\(key)-\(value)")
            }
        }
        return result
    }
}
