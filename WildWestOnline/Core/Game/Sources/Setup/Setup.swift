//
//  Setup.swift
//
//
//  Created by Hugues Telolahy on 19/05/2023.
//

public enum Setup {
    public static func createGame(
        playersCount: Int,
        inventory: Inventory,
        preferredFigure: String? = nil
    ) -> GameState {
        var figures = inventory.figures.shuffled()
        if let preferredFigure {
            figures = figures.starting(with: preferredFigure)
        }
        figures = Array(figures.prefix(playersCount))

        let deck = buildDeck(cardSets: inventory.cardSets)
            .shuffled()

        return buildGame(
            figures: figures,
            deck: deck,
            cards: inventory.cards
        )
    }

    public static func buildGame(
        figures: [String],
        deck: [String],
        cards: [String: Card]
    ) -> GameState {
        var deck = deck
        var players: [String: PlayersState.Player] = [:]
        var hand: [String: [String]] = [:]

        for figure in figures {
            let id = figure
            let player = buildPlayer(figure: figure, cards: cards)
            players[id] = player
            hand[id] = Array(1...player.health).compactMap { _ in
                if deck.isNotEmpty {
                    deck.removeFirst()
                } else {
                    nil
                }
            }
        }

        return GameState(
            players: .init(
                content: players
            ),
            cardLocations: .init(
                deck: deck,
                discard: [],
                arena: [],
                hand: hand,
                inPlay: [:]
            ),
            playOrder: figures,
            startOrder: figures,
            playedThisTurn: [:],
            chooseOne: [:],
            active: [:],
            playMode: [:],
            sequence: [],
            cards: cards,
            waitDelayMilliseconds: 0
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

private extension Setup {
    static func buildPlayer(
        figure: String,
        cards: [String: Card]
    ) -> PlayersState.Player {
        guard let figureObj = cards[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        guard let health = figureObj.attributes[.maxHealth] else {
            fatalError("missing attribute maxHealth")
        }

        return .init(
            health: health,
            maxHealth: health,
            figure: figure,
            abilities: figureObj.abilities.union([figure]),
            attributes: figureObj.attributes
        )
    }
}
