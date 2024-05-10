//
//  GamePlayViewConnector.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 10/05/2024.
//

import AppCore
import GameCore
import Redux

public extension Connectors {
    struct GamePlayViewConnector: Connector {
        public init() {}

        public func connect(state: AppState) -> GamePlayView.State {
            guard let game = state.game else {
                fatalError("Missing current game")
            }

            return .init(
                players: game.playerItems,
                message: game.message,
                chooseOneActions: game.chooseOneActions,
                handActions: game.handActions,
                occurredEvent: game.event
            )
        }
    }
}

private extension GameState {
    var playerItems: [GamePlayView.State.PlayerItem] {
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
