//
//  IgnoreLimitPerTurn.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

@testable import GameCore

extension Card.ActionID {
    static let ignoreLimitPerTurn = Card.ActionID(rawValue: "ignoreLimitPerTurn")
}

public extension GameFeature.Action {
    static var ignoreLimitPerTurn: Self {
        .init(
            actionID: .ignoreLimitPerTurn
        )
    }
}

struct IgnoreLimitPerTurn: GameActionHandler {
    static let id = Card.ActionID.ignoreLimitPerTurn

    static func handle(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
        guard let playIndex = state.queue.firstIndex(where: {
            $0.name == .play
        }) else {
            fatalError("Missing play action")
        }

        var playAction = state.queue[playIndex]
        guard let limitPerTurnIndex = playAction.selectors.firstIndex(where: {
            if case let .require(requirement) = $0,
               case .playLimitThisTurn = requirement {
                return true
            } else {
                return false
            }
        }) else {
            return state
        }

        playAction.selectors.remove(at: limitPerTurnIndex)
        var queue = state.queue
        queue[playIndex] = playAction

        var state = state
        state.queue = queue

        return state
    }
}
