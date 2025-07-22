//
//  GameSetupService.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

public enum GameSetupService {
    public static func buildGame(
        playersCount: Int,
        inventory: Inventory,
        preferredFigure: String? = nil
    ) -> GameFeature.State {
        let figures = inventory.figures.shuffled().starting(with: preferredFigure)
        return buildGame(
            figures: Array(figures.prefix(playersCount)),
            deck: buildDeck(deck: inventory.deck).shuffled(),
            cards: inventory.cards.toDictionary,
            playerAbilities: inventory.playerAbilities
        )
    }

    public static func buildGame(
        figures: [String],
        deck: [String],
        cards: [String: Card],
        playerAbilities: [String]
    ) -> GameFeature.State {
        var deck = deck
        let players = figures.reduce(into: [String: GameFeature.State.Player]()) { result, figure in
            result[figure] = buildPlayer(
                figure: figure,
                cards: cards,
                deck: &deck,
                playerAbilities: playerAbilities
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
            isOver: false,
            playMode: [:],
            actionDelayMilliSeconds: 0
        )
    }

    public static func buildDeck(deck: [String: [String]]) -> [String] {
        deck.reduce(into: [String]()) { result, card in
            result.append(contentsOf: card.value.map { "\(card.key)-\($0)" })
        }
    }
}

private extension GameSetupService {
    static func buildPlayer(
        figure: String,
        cards: [String: Card],
        deck: inout [String],
        playerAbilities: [String]
    ) -> GameFeature.State.Player {
        guard let figureObj = cards[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        guard let maxHealth = figureObj.amountOfActiveEffect(named: .setMaxHealth) else {
            fatalError("unexpected")
        }

        let weapon = 1
        let drawCards = figureObj.amountOfActiveEffect(named: .setDrawCards) ?? 1
        let magnifying = figureObj.amountOfActiveEffect(named: .increaseMagnifying) ?? 0
        let remoteness = figureObj.amountOfActiveEffect(named: .increaseRemoteness) ?? 0
        let handLimit = figureObj.amountOfActiveEffect(named: .setHandLimit) ?? 0
        let abilities = [figure] + playerAbilities
        let playLimitPerTurn = figureObj.playlimitPerTurn ?? [:]

        let hand = Array(1...maxHealth).compactMap { _ in
            if deck.isNotEmpty {
                deck.removeFirst()
            } else {
                nil
            }
        }

        return .init(
            figure: figure,
            health: maxHealth,
            maxHealth: maxHealth,
            hand: hand,
            inPlay: [],
            magnifying: magnifying,
            remoteness: remoteness,
            weapon: weapon,
            abilities: abilities,
            handLimit: handLimit,
            playLimitPerTurn: playLimitPerTurn,
            drawCards: drawCards
        )
    }
}

private extension Card {
    func amountOfActiveEffect(named action: Card.Effect.Name) -> Int? {
        behaviour[.permanent]?.first { $0.name == action }?.amount
    }

    var playlimitPerTurn: [String: Int]? {
        behaviour[.permanent]?.first { $0.name == .setPlayLimitPerTurn }?.amountPerTurn
    }
}
