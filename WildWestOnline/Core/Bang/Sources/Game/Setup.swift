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
        let weapon = 1
        let magnifying = 0 + figureObj.increasedMagnifying
        let remoteness = 0 + figureObj.increasedRemoteness
        let handLimit = figureObj.handLimit ?? 0
        let abilities = [figure] + defaultAbilities
        let playLimitPerTurn = figureObj.playlimitPerTurn

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
            weapon: weapon,
            abilities: abilities,
            handLimit: handLimit,
            playLimitPerTurn: playLimitPerTurn
        )
    }
}

private extension Card {
    var maxHealth: Int {
        guard let effect = onActive.first(where: { $0.action == .setMaxHealth }),
              let selector = effect.selectors.first,
              case .setAmount(let value) = selector else {
            fatalError("unexpected")
        }

        return value
    }

    var increasedMagnifying: Int {
        guard let effect = onActive.first(where: { $0.action == .increaseMagnifying }),
              let selector = effect.selectors.first,
              case .setAmount(let value) = selector else {
            return 0
        }

        return value
    }

    var increasedRemoteness: Int {
        guard let effect = onActive.first(where: { $0.action == .increaseRemoteness }),
              let selector = effect.selectors.first,
              case .setAmount(let value) = selector else {
            return 0
        }

        return value
    }

    var handLimit: Int? {
        guard let effect = onActive.first(where: { $0.action == .setHandLimit }),
              let selector = effect.selectors.first,
              case .setAmount(let value) = selector else {
            return nil
        }

        return value
    }

    var playlimitPerTurn: [String: Int] {
        guard let effect = onActive.first(where: { $0.action == .setPlayLimitPerTurn }),
              let selector = effect.selectors.first,
              case .setAmountPerCard(let value) = selector else {
            return [:]
        }

        return value
    }
}
