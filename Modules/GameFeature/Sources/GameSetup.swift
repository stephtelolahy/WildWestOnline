//
//  GameSetup.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

public enum GameSetup {
    public static func buildGame(
        playersCount: Int,
        cards: [Card],
        deck: [String: [String]],
        preferredFigure: String? = nil
    ) -> GameFeature.State {
        let figures = cards.names(for: .figure)
            .shuffled()
            .starting(with: preferredFigure)
        return buildGame(
            figures: Array(figures.prefix(playersCount)),
            deck: buildDeck(deck: deck).shuffled(),
            cards: cards.toDictionary,
            playerAbilities: cards.names(for: .ability)
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
            actionDelayMilliSeconds: 0,
            autoActivatePlayableCardsOnIdle: true
        )
    }

    static func buildDeck(deck: [String: [String]]) -> [String] {
        deck.reduce(into: [String]()) { result, card in
            result.append(contentsOf: card.value.map { "\(card.key)-\($0)" })
        }
    }
}

private extension GameSetup {
    static func buildPlayer(
        figure: String,
        cards: [String: Card],
        deck: inout [String],
        playerAbilities: [String]
    ) -> GameFeature.State.Player {
        guard let figureObj = cards[figure] else {
            fatalError("Missing figure named \(figure)")
        }

        guard let maxHealth = figureObj.amountOfPermanentEffect(named: .setMaxHealth) else {
            fatalError("Missing maxHealth for \(figure)")
        }

        let weapon = 1
        let cardsPerDraw = figureObj.amountOfPermanentEffect(named: .setCardsPerDraw) ?? 1
        let magnifying = figureObj.amountOfPermanentEffect(named: .increaseMagnifying) ?? 0
        let remoteness = figureObj.amountOfPermanentEffect(named: .increaseRemoteness) ?? 0
        let handLimit = figureObj.amountOfPermanentEffect(named: .setHandLimit) ?? 0
        let abilities = [figure] + playerAbilities
        let playLimitsPerTurn = figureObj.playlimitPerTurn ?? [:]
        let cardsPerTurn = 2

        let hand = Array(1...maxHealth).compactMap { _ in
            if deck.isNotEmpty {
                deck.removeFirst()
            } else {
                nil
            }
        }

        return .init(
            figure: figure,
            abilities: abilities,
            health: maxHealth,
            maxHealth: maxHealth,
            hand: hand,
            inPlay: [],
            weapon: weapon,
            magnifying: magnifying,
            remoteness: remoteness,
            handLimit: handLimit,
            cardsPerDraw: cardsPerDraw,
            playLimitsPerTurn: playLimitsPerTurn,
            cardsPerTurn: cardsPerTurn
        )
    }
}

private extension Card {
    func amountOfPermanentEffect(named action: Card.ActionName) -> Int? {
        effects.first { $0.trigger == .permanent && $0.action == action }?.amount
    }

    var playlimitPerTurn: [String: Int]? {
        effects.first { $0.trigger == .permanent && $0.action == .setPlayLimitsPerTurn }?.amountPerTurn
    }
}
