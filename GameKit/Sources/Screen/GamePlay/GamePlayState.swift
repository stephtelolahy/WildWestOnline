//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import Game
import Redux

// MARK: - Knownledge state
public struct GamePlayState: Codable, Equatable {
    public var gameState: GameState?

    static func from(globalState: AppState) -> GamePlayState {
        if let lastScreen = globalState.screens.last,
           case let .game(gameState) = lastScreen {
            gameState
        } else {
            .init()
        }
    }
}

// MARK: - Derived state
extension GamePlayState {
    var players: [Player] {
        guard let game = gameState else {
            return []
        }

        return game.playOrder.map { game.player($0) }
    }

    var message: String? {
        "Your turn"
    }
}

public enum GamePlayAction: Action, Codable, Equatable {
    case load
}

extension GamePlayState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? GameAction,
              let game = state.gameState else {
            return state
        }

        var state = state
        state.gameState = GameState.reducer(game, action)
        return state
    }
}
