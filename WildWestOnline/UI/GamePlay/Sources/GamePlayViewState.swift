// swiftlint:disable:this file_name
//
//  GamePlayViewState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//
// swiftlint:disable nesting

import AppCore
import Foundation
import GameCore

public extension GamePlayView {
    struct State: Equatable {
        public let players: [PlayerItem]
        public let message: String
        public let chooseOneData: ChooseOneData?
        public let handActions: [CardAction]
        public let topDiscard: String?
        public let topDeck: String?
        public let animationDelay: TimeInterval
        public let startOrder: [String]
        public let deckCount: Int
        public let occurredEvent: GameAction?

        public struct PlayerItem: Equatable {
            public let id: String
            public let imageName: String
            public let displayName: String
            public let health: Int
            public let maxHealth: Int
            public let handCount: Int
            public let inPlay: [String]
            public let isTurn: Bool
            public let isTargeted: Bool
            public let isEliminated: Bool
            public let role: String?
            public let userPhotoUrl: String?
        }

        public struct CardAction: Equatable {
            public let card: String
            public let action: GameAction?

            public init(card: String, action: GameAction?) {
                self.card = card
                self.action = action
            }
        }

        public struct ChooseOneData: Equatable {
            public let choiceType: ChoiceType
            public let options: [String]
            public let actions: [String: GameAction]

            public init(
                choiceType: ChoiceType,
                options: [String],
                actions: [String: GameAction]
            ) {
                self.choiceType = choiceType
                self.options = options
                self.actions = actions
            }
        }
    }

    static let deriveState: (AppState) -> State? = { state in
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

private extension GameState {
    var playerItems: [GamePlayView.State.PlayerItem] {
        self.startOrder.map { playerId in
            let playerObj = player(playerId)
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let handCount = playerObj.hand.count
            let equipment = playerObj.inPlay
            let isTurn = playerId == turn
            let isEliminated = !playOrder.contains(playerId)
            let isTargeted = sequence.contains { $0.isEffectTargeting(playerId) }

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
            "-"
        }
    }

    var chooseOneData: GamePlayView.State.ChooseOneData? {
        guard let chooseOne = chooseOne.first(where: { playMode[$0.key] == .manual }) else {
            return  nil
        }

        let options = chooseOne.value.options.reduce(into: [String: GameAction]()) {
            $0[$1] = .choose($1, player: chooseOne.key)
        }
        return .init(
            choiceType: chooseOne.value.type,
            options: chooseOne.value.options,
            actions: options
        )
    }

    var handActions: [GamePlayView.State.CardAction] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = self.active[playerId] ?? []

        let handCardActions = playerObj.hand.map { card in
            if activeCards.contains(card) {
                GamePlayView.State.CardAction(card: card, action: .play(card, player: playerId))
            } else {
                GamePlayView.State.CardAction(card: card, action: nil)
            }
        }

        let abilityActions = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                GamePlayView.State.CardAction(card: card, action: .play(card, player: playerId))
            } else {
                nil
            }
        }

        return handCardActions + abilityActions
    }
}
