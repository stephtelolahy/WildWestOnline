// swiftlint:disable:this file_name
//
//  GamePlayViewState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
// swiftlint:disable nesting

import AppCore
import GameCore
import Redux

public extension GamePlayView {
    struct State: Equatable {
        public let visiblePlayers: [PlayerItem]
        public let message: String
        public let chooseOneActions: [String: GameAction]
        public let handActions: [CardAction]
        public let events: [String]

        public struct PlayerItem: Equatable {
            public enum Status {
                case active
                case idle
                case eliminated
            }

            public let id: String
            public let imageName: String
            public let displayName: String
            public let hand: String
            public let health: String
            public let equipment: String
            public let status: Status
        }

        public struct CardAction: Equatable {
            public let card: String
            public let action: GameAction?

            public init(card: String, action: GameAction?) {
                self.card = card
                self.action = action
            }
        }
    }
}

public extension GamePlayView.State {
    static func from(globalState: AppState) -> Self? {
        guard let game = globalState.game else {
            return nil
        }

        return .init(
            visiblePlayers: game.visiblePlayers,
            message: game.message,
            chooseOneActions: game.chooseOneActions,
            handActions: game.handActions,
            events: game.events.reversed().map { String(describing: $0)}
        )
    }
}

private extension GameState {
    var visiblePlayers: [GamePlayView.State.PlayerItem] {
        startOrder.map { playerId in
            let playerObj = player(playerId)
            let handText = "[]\(playerObj.hand.count)"
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let health = max(0, playerObj.health)
            let damage = maxHealth - health
            let healthText = ""
            + Array(repeating: "♡", count: damage).joined()
            + Array(repeating: "♥", count: health).joined()
            let equipmentText = playerObj.inPlay.joined(separator: "-")

            let status: GamePlayView.State.PlayerItem.Status
            = if playerId == turn {
                .active
            } else if !playOrder.contains(playerId) {
                .eliminated
            } else {
                .idle
            }

            return GamePlayView.State.PlayerItem(
                id: playerId,
                imageName: playerObj.figure,
                displayName: playerObj.figure.uppercased(),
                hand: handText,
                health: healthText,
                equipment: equipmentText,
                status: status
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

    var chooseOneActions: [String: GameAction] {
        guard let chooseOne = chooseOne.first(where: { playMode[$0.key] == .manual }) else {
            return  [:]
        }

        return chooseOne.value.options.reduce(into: [String: GameAction]()) {
            $0[$1] = .choose($1, player: chooseOne.key)
        }
    }

    var handActions: [GamePlayView.State.CardAction] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = self.active[playerId] ?? []

        let handCardActions = playerObj.hand .map { card in
            if activeCards.contains(card) {
                GamePlayView.State.CardAction(card: card, action: .play(card, player: playerId))
            } else {
                GamePlayView.State.CardAction(card: card, action: nil)
            }
        }

        let abilityActions: [GamePlayView.State.CardAction] = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                GamePlayView.State.CardAction(card: card, action: .play(card, player: playerId))
            } else {
                nil
            }
        }

        return handCardActions + abilityActions
    }
}
