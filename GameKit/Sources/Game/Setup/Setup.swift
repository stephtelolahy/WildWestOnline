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
        cardRef: [String: Card]
    ) -> GameState {
        var deck = deck.shuffled()
        let players: [Player] = figures.map {
            Self.buildPlayer(
                figure: $0,
                deck: &deck,
                cardRef: cardRef
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
            deck: deck,
            discard: [],
            arena: [],
            chooseOne: [:],
            active: [:],
            playMode: [:],
            sequence: [],
            cardRef: cardRef
        )
    }

    private static func buildPlayer(
        figure: String,
        deck: inout [String],
        cardRef: [String: Card]
    ) -> Player {
        guard let figureObj = cardRef[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        guard let health = figureObj.attributes[.maxHealth] else {
            fatalError("missing attribute maxHealth")
        }

        let hand: [String] = Array(1...health).compactMap { _ in
            if deck.isNotEmpty {
                deck.removeFirst()
            } else {
                nil
            }
        }

        var abilities: Set<String> = figureObj.abilities
        abilities.insert(figure)

        return Player(
            id: figure,
            figure: figure,
            abilities: abilities,
            attributes: figureObj.attributes,
            health: health,
            hand: hand,
            inPlay: []
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
