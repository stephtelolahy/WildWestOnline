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

        for figure in figures {
            let id = figure
            var player = buildPlayer(figure: figure, cards: cards)
            player.hand = Array(1...player.health).compactMap { _ in
                if deck.isNotEmpty {
                    deck.removeFirst()
                } else {
                    nil
                }
            }
            players[id] = player
        }

        return GameState(
            players: players,
            cards: cards,
            deck: deck,
            discard: [],
            discovered: [],
            startOrder: figures,
            playOrder: figures,
            turn: nil,
            turnPlayedBang: 0,
            queue: [],
            chooseOne: [:],
            active: [:],
            winner: nil,
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

        var maxHealth = 0
        for ability in figureObj.passive {
            if case .setMaxHealth(let value) = ability {
                maxHealth = value
                break
            }
        }

        return .init(
            figure: figure,
            abilities: [figure],
            hand: [],
            inPlay: [],
            health: maxHealth,
            maxHealth: maxHealth,
            weapon: 1,
            handLimit: 0,
            magnifying: 0,
            remoteness: 0,
            flippedCards: 1
        )
    }
}
