// swiftlint:disable:this file_name
//
//  GameViewConnector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//
// swiftlint:disable nesting

import Redux
import AppCore
import GameCore
import NavigationCore

public struct GameViewConnector: Connector {
    public init() {}

    public func deriveState(_ state: AppState) -> GameView.State? {
        guard let game = state.game else {
            return nil
        }

        return .init(
            players: game.playerItems,
            message: game.message,
            chooseOne: game.chooseOne,
            handCards: game.handCards,
            topDiscard: game.field.discard.first,
            topDeck: game.field.deck.first,
            animationDelay: Double(game.config.waitDelayMilliseconds) / 1000.0,
            startOrder: game.round.startOrder,
            deckCount: game.field.deck.count
        )
    }

    public func embedAction(_ action: GameView.Action, _ state: AppState) -> Any {
        guard let game = state.game else {
            fatalError("unexpected")
        }

        switch action {
        case .didAppear:
            return GameAction.startTurn(player: game.startingPlayerId)

        case .didTapCloseButton:
            return GameSetupAction.quit

        case .didPlayCard(let card):
            guard let controlledId = game.controlledPlayerId else {
                fatalError("unexpected")
            }

            return GameAction.preparePlay(card, player: controlledId)

        case .didChooseOption(let option):
            guard let controlledId = game.controlledPlayerId else {
                fatalError("unexpected")
            }

            return GameAction.prepareChoose(option, player: controlledId)
        }
    }
}

private extension GameState {
    var playerItems: [GameView.State.PlayerItem] {
        self.round.startOrder.map { playerId in
            let playerObj = player(playerId)
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let handCount = field.hand.get(playerId).count
            let equipment = field.inPlay.get(playerId)
            let isTurn = playerId == round.turn
            let isEliminated = !round.playOrder.contains(playerId)
            let isTargeted = sequence.queue.contains { $0.isEffectTargeting(playerId) }

            return .init(
                id: playerId,
                imageName: playerObj.figure,
                displayName: playerObj.figure.uppercased(),
                health: health,
                maxHealth: maxHealth,
                handCount: handCount,
                inPlay: equipment,
                isTurn: isTurn,
                isTargeted: isTargeted,
                isEliminated: isEliminated,
                role: nil,
                userPhotoUrl: nil
            )
        }
    }

    var message: String {
        if let turn = round.turn {
            "\(turn.uppercased())'s turn"
        } else {
            "-"
        }
    }

    var chooseOne: GameView.State.ChooseOne? {
        guard let controlledId = controlledPlayerId,
              let chooseOne = sequence.chooseOne[controlledId] else {
            return  nil
        }

        return .init(
            choiceType: chooseOne.type.rawValue,
            options: chooseOne.options
        )
    }

    var handCards: [GameView.State.HandCard] {
        guard let playerId = players.first(where: { config.playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = sequence.active[playerId] ?? []

        let hand = field.hand.get(playerId).map { card in
            GameView.State.HandCard(
                card: card,
                active: activeCards.contains(card)
            )
        }

        let abilities = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                GameView.State.HandCard(
                    card: card,
                    active: true
                )
            } else {
                nil
            }
        }

        return hand + abilities
    }

    var startingPlayerId: String {
        round.playOrder.first!
    }

    var controlledPlayerId: String? {
        round.startOrder.first(where: { config.playMode[$0] == .manual })
    }
}
