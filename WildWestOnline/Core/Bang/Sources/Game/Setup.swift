//
//  Setup.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

public enum Setup {
    public static func buildDeck(cardSets: [String: [String]]) -> [String] {
        cardSets.reduce(into: [String]()) { result, card in
            result.append(contentsOf: card.value.map { "\(card.key)-\($0)" })
        }
    }

    public static func buildGame(
        figures: [String],
        deck: [String],
        cards: [String: Card],
        defaultAbilities: [String]
    ) -> GameState {
        var deck = deck
        let players = figures.reduce(into: [String: Player]()) { result, figure in
            result[figure] = buildPlayer(
                figure: figure,
                cards: cards,
                deck: &deck,
                defaultAbilities: defaultAbilities
            )
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
            active: [:],
            isOver: false
        )
    }
}

private extension Setup {
    static func buildPlayer(
        figure: String,
        cards: [String: Card],
        deck: inout [String],
        defaultAbilities: [String]
    ) -> Player {
        guard let figureObj = cards[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        let maxHealth = figureObj.maxHealth
        let magnifying = figureObj.magnifying
        let remoteness = figureObj.remoteness
        let handLimit = figureObj.handLimit
        let abilities = [figure] + defaultAbilities

        let hand = Array(1...maxHealth).compactMap { _ in
            if deck.isNotEmpty {
                deck.removeFirst()
            } else {
                nil
            }
        }

        return .init(
            health: maxHealth,
            maxHealth: maxHealth,
            hand: hand,
            inPlay: [],
            magnifying: magnifying,
            remoteness: remoteness,
            weapon: 1,
            abilities: abilities,
            handLimit: handLimit
        )
    }
}

private extension Card {
    var maxHealth: Int {
        for effect in passive {
            if case .setMaxHealth = effect.action,
               let selector = effect.selectors.first,
               case .setAmount(let value) = selector {
                return value
            }
        }

        fatalError("unexpected")
    }

    var magnifying: Int {
        for effect in passive {
            if case .setMagnifying = effect.action,
               let selector = effect.selectors.first,
               case .setAmount(let value) = selector {
                return value
            }
        }

        return 0
    }

    var remoteness: Int {
        for effect in passive {
            if case .setRemoteness = effect.action,
               let selector = effect.selectors.first,
               case .setAmount(let value) = selector {
                return value
            }
        }

        return 0
    }

    var handLimit: Int {
        for effect in passive {
            if case .setHandLimit = effect.action,
               let selector = effect.selectors.first,
               case .setAmount(let value) = selector {
                return value
            }
        }

        return 0
    }
}
