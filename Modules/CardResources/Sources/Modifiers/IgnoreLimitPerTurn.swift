//
//  IncrementCardsPerTurn.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

import CardDefinition
@testable import GameFeature

extension Card.QueueModifier {
    static let ignoreLimitPerTurn = Card.QueueModifier(rawValue: "ignoreLimitPerTurn")
}

struct IgnoreLimitPerTurn: QueueModifierHandler {
    static let id = Card.QueueModifier.ignoreLimitPerTurn

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
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
            return state.queue
        }

        playAction.selectors.remove(at: limitPerTurnIndex)
        var queue = state.queue
        queue[playIndex] = playAction
        return queue
    }
}
