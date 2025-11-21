//
//  GameSetup.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

public enum PlayModeSetup {
    case oneManual
    case allAuto
}

public enum GameSetup {
    public static func buildGame(
        playersCount: Int,
        cards: [Card],
        deck: [String: [String]],
        actionDelayMilliSeconds: Int,
        preferredFigure: String? = nil,
        playModeSetup: PlayModeSetup? = nil
    ) -> GameFeature.State {
        var figures = cards.names(for: .figure)
            .shuffled()
            .starting(with: preferredFigure)
        figures = Array(figures.prefix(playersCount))

        let playMode: [String: GameFeature.State.PlayMode] =
        switch playModeSetup {
        case .oneManual:
            figures.reduce(into: [:]) {
                $0[$1] = $1 == figures[0] ? .manual : .auto
            }

        case .allAuto:
            figures.reduce(into: [:]) {
                $0[$1] = .auto
            }

        case .none:
            [:]
        }

        return buildGame(
            figures: figures,
            deck: buildDeck(deck: deck).shuffled(),
            cards: cards.toDictionary,
            auras: cards.names(for: .ability),
            playMode: playMode,
            actionDelayMilliSeconds: actionDelayMilliSeconds
        )
    }

    public static func buildGame(
        figures: [String],
        deck: [String],
        cards: [String: Card],
        auras: [String],
        playMode: [String: GameFeature.State.PlayMode] = [:],
        actionDelayMilliSeconds: Int = 0
    ) -> GameFeature.State {
        var deck = deck
        let players = figures.reduce(into: [String: GameFeature.State.Player]()) { result, figure in
            result[figure] = buildPlayer(
                figure: figure,
                cards: cards,
                deck: &deck
            )
        }
        return .init(
            players: players,
            playOrder: figures,
            startOrder: figures,
            deck: deck,
            discard: [],
            cards: cards,
            discovered: [],
            queue: [],
            playable: [:],
            auras: auras,
            playedThisTurn: [:],
            isOver: false,
            playMode: playMode,
            actionDelayMilliSeconds: actionDelayMilliSeconds,
            showPlayableCards: true
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
        deck: inout [String]
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
        let playLimitsPerTurn = figureObj.playlimitPerTurn ?? [:]

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
            weapon: weapon,
            magnifying: magnifying,
            remoteness: remoteness,
            hand: hand,
            inPlay: [],
            abilities: [figure],
            maxHealth: maxHealth,
            handLimit: handLimit,
            cardsPerDraw: cardsPerDraw,
            playLimitsPerTurn: playLimitsPerTurn
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
