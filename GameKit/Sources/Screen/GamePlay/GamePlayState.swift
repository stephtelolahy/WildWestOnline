//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import Game
import Redux

public struct GamePlayState: Codable, Equatable {
    private var gameState: GameState?

    var players: [Player] {
        guard let game = gameState else {
            return []
        }

        return game.playOrder.map { game.player($0) }
    }

    var message: String? {
        "Your turn"
    }

    init(gameState: GameState? = nil) {
        self.gameState = gameState
    }

    static func from(globalState: AppState) -> GamePlayState {
        if let lastScreen = globalState.screens.last,
           case let .game(gameState) = lastScreen {
            gameState
        } else {
            .init()
        }
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
