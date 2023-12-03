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
    var selectedPlayer: String?

    public init(gameState: GameState) {
        self.gameState = gameState
    }
}

// MARK: - Derived state
extension GamePlayState {
    var players: [Player] {
        gameState.playOrder.map { gameState.player($0) }
    }

    var message: String {
        if let active = gameState.active {
            "active: \(active.cards)"
        } else if let chooseOne = gameState.chooseOne {
            "chooseOne: \(chooseOne.options.keys)"
        } else if let turn = gameState.turn {
            "turn: \(turn)"
        } else {
            ""
        }
    }
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
