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
        playOrder.map { playerId in
            let playerObj = player(playerId)

            var activeActions: [String: GameAction] = [:]
            if let activeCards = active[playerId] {
                activeActions = activeCards.reduce(into: [String: GameAction]()) {
                    $0[$1] = .play($1, player: playerId)
                }
            }

            let highlighted = playerId == turn
            let handText = "[]\(playerObj.hand.count)"
            let health = max(0, playerObj.health)
            let maxHealth = playerObj.attributes[.maxHealth] ?? 0
            let healthText = ""
            + Array(repeating: "♡", count: maxHealth - health).joined()
            + Array(repeating: "♥", count: health).joined()

            let equipmentText = playerObj.inPlay.joined(separator: "-")

            return PlayerItem(
                id: playerId,
                imageName: playerObj.figure,
                displayName: playerObj.figure.uppercased(),
                status: "\(handText)\t\(healthText)",
                equipment: equipmentText,
                activeActions: activeActions,
                highlighted: highlighted
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

    var chooseOneAlertData: [String: GameAction] {
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
    let status: String
    let equipment: String
    let activeActions: [String: GameAction]
    let highlighted: Bool
}
