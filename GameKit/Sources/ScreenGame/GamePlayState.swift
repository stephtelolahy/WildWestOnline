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
    private var selectedPlayer: String?

    public init(gameState: GameState, selectedPlayer: String? = nil) {
        self.gameState = gameState
        self.selectedPlayer = selectedPlayer
    }
}

// MARK: - Derived state
extension GamePlayState {
    var players: [PlayerItem] {
        gameState.playOrder.map {
            let player = gameState.player($0)
            var waitingActions: Int?
            if let active = gameState.active,
               player.id == active.player {
                waitingActions = active.cards.count
            }
            if let chooseOne = gameState.chooseOne, chooseOne.chooser == player.id {
                waitingActions = chooseOne.options.count
            }
            return PlayerItem(
                id: player.id,
                imageName: player.figure,
                displayName: player.figure.uppercased(),
                status: "[]\(player.hand.count)\t❤️\(player.health)/\(player.attributes[.maxHealth] ?? 0)",
                equipment: player.inPlay.cards.joined(separator: "-"),
                waitingActions: waitingActions,
                highlighted: player.id == selectedPlayer
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
    let waitingActions: Int?
    let highlighted: Bool
}

public enum GamePlayAction: Action, Codable, Equatable {
    case onSelectPlayer(String)
}

public extension GamePlayState {
    static let reducer: Reducer<Self> = { state, action in
        var state = state

        if let action = action as? GamePlayAction {
            switch action {
            case let .onSelectPlayer(playerId):
                state.selectedPlayer = playerId
            }
        }

        if let action = action as? GameAction {
            state.gameState = GameState.reducer(state.gameState, action)
        }

        return state
    }
}
