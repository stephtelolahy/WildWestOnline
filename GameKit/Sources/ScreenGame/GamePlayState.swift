//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import Foundation
import Game
import Redux

// MARK: - Knownledge state
public struct GamePlayState: Codable, Equatable {
    public var gameState: GameState

    var activeSheetData: [String: GameAction] = [:]

    public init(gameState: GameState) {
        self.gameState = gameState
    }
}

// MARK: - Derived state
extension GamePlayState {
    var players: [PlayerItem] {
        gameState.playOrder.map {
            let player = gameState.player($0)

            var activeActions: [String: GameAction] = [:]
            if let active = gameState.active,
               player.id == active.player {
                activeActions = active.cards.reduce(into: [String: GameAction]()) {
                    $0[$1] = .play($1, player: player.id)
                }
            }

            let highlighted = gameState.active?.player == player.id || gameState.chooseOne?.chooser == player.id

            return PlayerItem(
                id: player.id,
                imageName: player.figure,
                displayName: player.figure.uppercased(),
                status: "[]\(player.hand.count)\t❤️\(player.health)/\(player.attributes[.maxHealth] ?? 0)",
                equipment: player.inPlay.cards.joined(separator: "-"),
                activeActions: activeActions,
                highlighted: highlighted
            )
        }
    }

    var message: String {
        if let turn = gameState.turn {
            "turn: \(turn)"
        } else {
            ""
        }
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

public enum GamePlayAction: Action, Codable, Equatable {
    case selectPlayer(String)
    case showActiveSheet
}

public extension GamePlayState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state

        if let action = action as? GameAction {
            state.gameState = GameState.reducer(state.gameState, action)
        }

        if let action = action as? GamePlayAction {
            switch action {
            case let .selectPlayer(playerId):
                state.activeSheetData = state.players.first { $0.id == playerId }?.activeActions ?? [:]

            case .showActiveSheet:
                state.activeSheetData = [:]
            }
        }

        return state
    }
}
