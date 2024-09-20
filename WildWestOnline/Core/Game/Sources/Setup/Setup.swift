//
//  Setup.swift
//
//
//  Created by Hugues Telolahy on 19/05/2023.
//

public enum Setup {
    public static func buildGame(
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
        var players: [String: Player] = [:]
        var hand: [String: [String]] = [:]
        var inPlay: [String: [String]] = [:]

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
            inPlay[id] = []
        }

        return GameState(
            players: players,
            field: .init(
                deck: deck,
                discard: [],
                arena: [],
                hand: hand,
                inPlay: inPlay
            ),
            round: .init(
                startOrder: figures,
                playOrder: figures,
                turn: nil
            ),
            sequence: .init(
                queue: [],
                chooseOne: [:],
                active: [:],
                played: [:],
                winner: nil
            ),
            cards: cards,
            waitDelaySeconds: 0,
            playMode: [:]
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
    ) -> Player {
        guard let figureObj = cards[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        let health = figureObj.attributes.get(.maxHealth)
        return .init(
            health: health,
            attributes: figureObj.attributes,
            abilities: figureObj.abilities.union([figure]),
            figure: figure
        )
    }
}
