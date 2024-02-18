//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import GameCore
import Redux

protocol GamePlayState {
    var visiblePlayers: [PlayerItem] { get }
    var message: String { get }
    var chooseOneActions: [String: GameAction] { get }
    var handActions: [CardAction] { get }
}

struct PlayerItem {
    enum State {
        case active
        case idle
        case eliminated
    }

    let id: String
    let imageName: String
    let displayName: String
    let hand: String
    let health: String
    let equipment: String
    let state: State
}

struct CardAction: Equatable {
    let card: String
    let action: GameAction?
}

public enum GamePlayAction: Action, Codable, Equatable {
    case quit
}

// MARK: - Derived state
extension GameState: GamePlayState {
    var visiblePlayers: [PlayerItem] {
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

    var chooseOneActions: [String: GameAction] {
        guard let chooseOne = chooseOne.first(where: { playMode[$0.key] == .manual }) else {
            return  [:]
        }

        return chooseOne.value.options.reduce(into: [String: GameAction]()) {
            $0[$1] = .choose($1, player: chooseOne.key)
        }
    }

    var handActions: [CardAction] {
        guard let playerId = players.first(where: { playMode[$0.key] == .manual })?.key,
              let playerObj = players[playerId] else {
            return []
        }

        let activeCards = self.active[playerId] ?? []

        let handCardActions = playerObj.hand .map { card in
            if activeCards.contains(card) {
                CardAction(card: card, action: .play(card, player: playerId))
            } else {
                CardAction(card: card, action: nil)
            }
        }

        let abilityActions: [CardAction] = playerObj.abilities.compactMap { card in
            if activeCards.contains(card) {
                CardAction(card: card, action: .play(card, player: playerId))
            } else {
                nil
            }
        }

        return handCardActions + abilityActions
    }
}
