//
//  GamePlayUIKitViewConnector.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//
// swiftlint:disable no_magic_numbers

import AppCore
import GameCore
import Redux

public extension Connectors {
    struct GamePlayUIKitViewConnector: Connector {
        public init() {}

        public func connect(state: AppState) -> GamePlayUIKitView.State? {
            guard let game = state.game else {
                return nil
            }

            return .init(
                players: game.playerItems,
                message: game.message,
                chooseOneData: game.chooseOneData,
                handActions: game.handActions,
                topDiscard: game.discard.first,
                topDeck: game.deck.first,
                animationDelay: Double(game.waitDelayMilliseconds) / 1000.0,
                startOrder: game.startOrder,
                deckCount: game.deck.count,
                occurredEvent: game.event
            )
        }
    }
}

private extension GameState {
    var playerItems: [GamePlayUIKitView.State.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = player(playerId)
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)

            let isTargeted = self.sequence.contains { action in
                if case .effect(_, let ctx) = action,
                   ctx.resolvingTarget == playerId {
                    return true
                } else {
                    return false
                }
            }

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
        if let turn {
            "\(turn.uppercased())'s turn"
        } else {
            ""
        }
    }

    var chooseOneData: GamePlayUIKitView.State.ChooseOneData? {
        guard let chooseOne = chooseOne.first(where: { playMode[$0.key] == .manual }) else {
            return  nil
        }

        let options = chooseOne.value.options.reduce(into: [String: GameAction]()) {
            $0[$1] = .choose($1, player: chooseOne.key)
        }
        return .init(choiceType: chooseOne.value.type, actions: options)
    }

    var handActions: [GamePlayUIKitView.State.CardAction] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = self.active[playerId] ?? []

        let handCardActions = playerObj.hand.map { card in
            if activeCards.contains(card) {
                GamePlayUIKitView.State.CardAction(card: card, action: .play(card, player: playerId))
            } else {
                GamePlayUIKitView.State.CardAction(card: card, action: nil)
            }
        }

        let abilityActions = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                GamePlayUIKitView.State.CardAction(card: card, action: .play(card, player: playerId))
            } else {
                nil
            }
        }

        return handCardActions + abilityActions
    }
}