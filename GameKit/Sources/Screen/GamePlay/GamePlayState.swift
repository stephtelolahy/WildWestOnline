//
//  GamePlayState.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//
import Game
import Redux

public struct GamePlayState: Codable, Equatable {
    var players: [Player]
    var message: String?

    static func from(globalState: AppState) -> GamePlayState {
        if let lastScreen = globalState.screens.last,
           case let .game(gameState) = lastScreen {
            gameState
        } else {
            .init(players: [])
        }
    }
}

public enum GamePlayAction: Action, Codable, Equatable {
    case load
}

extension GamePlayState {
    static let reducer: Reducer<Self> = { state, _ in
        state
    }
}
