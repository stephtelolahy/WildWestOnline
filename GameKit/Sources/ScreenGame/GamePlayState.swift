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

    public init(gameState: GameState) {
        self.gameState = gameState
    }
}

enum BoardItem {
    case player(String)
    case empty
    case discard(String?)
}

extension BoardItem: Identifiable {
    var id: String {
        switch self {
        case let .player(id):
            id

        case .empty:
            UUID().uuidString

        case .discard:
            "discard"
        }
    }
}

// MARK: - Derived state
extension GamePlayState {
    /// Array of size 3x3
    var boardItem: [BoardItem] {
        []
    }

    var players: [Player] {
        gameState.playOrder.map { gameState.player($0) }
    }

    var message: String? {
        if let active = gameState.active {
            "active: \(active.cards)"
        } else if let chooseOne = gameState.chooseOne {
            "chooseOne: \(chooseOne.options.keys)"
        } else {
            "turn: \(gameState.turn ?? "")"
        }
    }
}

public enum GamePlayAction: Action, Codable, Equatable {
    case load
}

public extension GamePlayState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? GameAction else {
            return state
        }

        return .init(gameState: GameState.reducer(state.gameState, action))
    }
}
