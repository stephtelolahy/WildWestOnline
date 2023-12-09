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
    // TODO: bind to GameState directly
    var selectedPlayer: String?

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
            if let activeCards = gameState.active[player.id] {
                activeActions = activeCards.reduce(into: [String: GameAction]()) {
                    $0[$1] = .play($1, player: player.id)
                }
            }

            let highlighted = gameState.active[player.id] != nil || gameState.chooseOne[player.id] != nil

            return PlayerItem(
                id: player.id,
                imageName: player.figure,
                displayName: player.figure.uppercased(),
                status: "[]\(player.hand.count)\t❤️\(player.health)/\(player.attributes[.maxHealth] ?? 0)",
                equipment: player.inPlay.joined(separator: "-"),
                activeActions: activeActions,
                highlighted: highlighted
            )
        }
    }

    var message: String {
        if let turn = gameState.turn {
            "\(turn.uppercased())'s turn"
        } else {
            ""
        }
    }

    var activeSheetData: [String: GameAction] {
        players.first {
            $0.id == selectedPlayer && gameState.playMode[$0.id] == .manual
        }?.activeActions ?? [:]
    }

    var chooseOneAlertData: [String: GameAction] {
        guard let chooseOne = gameState.chooseOne.first,
              gameState.playMode[chooseOne.key] == .manual else {
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

enum GamePlayAction: Action, Codable, Equatable {
    case didSelectPlayer(String)
    case didShowActiveSheet
    case didShowChooseOneAlert
}

public extension GamePlayState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state

        if let action = action as? GameAction {
            state.gameState = GameState.reducer(state.gameState, action)
        }

        if let action = action as? GamePlayAction {
            switch action {
            case let .didSelectPlayer(playerId):
                state.selectedPlayer = playerId

            case .didShowActiveSheet:
                state.selectedPlayer = nil

            case .didShowChooseOneAlert:
                break
            }
        }

        return state
    }
}
