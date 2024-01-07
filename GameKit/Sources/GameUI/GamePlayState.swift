// swiftlint:disable:this file_name
//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Game

// MARK: - Derived state
extension GameState {
    var visiblePlayers: [PlayerItem] {
        startOrder.map { playerId in
            let playerObj = player(playerId)

            var activeActions: [String: GameAction] = [:]
            if let activeCards = active[playerId] {
                activeActions = activeCards.reduce(into: [String: GameAction]()) {
                    $0[$1] = .play($1, player: playerId)
                }
            }

            let handText = "[]\(playerObj.hand.count)"
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let health = max(0, playerObj.health)
            let damage = maxHealth - health
            let healthText = ""
            + Array(repeating: "♡", count: damage).joined()
            + Array(repeating: "♥", count: health).joined()
            let equipmentText = playerObj.inPlay.joined(separator: "-")

            let state: PlayerItem.State
            = if playerId == turn {
                .active
            } else if !playOrder.contains(playerId) {
                .eliminated
            } else {
                .idle
            }

            return PlayerItem(
                id: playerId,
                imageName: playerObj.figure,
                displayName: playerObj.figure.uppercased(),
                hand: handText,
                health: healthText,
                equipment: equipmentText,
                activeActions: activeActions,
                state: state
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

    var activeActions: [String: GameAction] {
        visiblePlayers.first { playMode[$0.id] == .manual }?.activeActions ?? [:]
    }

    var chooseOneActions: [String: GameAction] {
        guard let chooseOne = chooseOne.first,
              playMode[chooseOne.key] == .manual else {
            return  [:]
        }

        return chooseOne.value
    }
}

struct PlayerItem: Identifiable {
    let id: String
    let imageName: String
    let displayName: String
    let hand: String
    let health: String
    let equipment: String
    let activeActions: [String: GameAction]
    let state: State

    enum State {
        case active
        case idle
        case eliminated
    }
}
