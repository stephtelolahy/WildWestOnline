//
//  IncrementRequiredMisses.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

@testable import GameCore

extension Card.ActionID {
    static let incrementRequiredMisses = Card.ActionID(rawValue: "incrementRequiredMisses")
}

public extension GameFeature.Action {
    static func incrementRequiredMisses(_ amount: Int, player: String) -> Self {
        .init(
            actionID: .incrementRequiredMisses,
            targetedPlayer: player,
            amount: amount
        )
    }
}

struct IncrementRequiredMisses: GameActionHandler {
    static let id = Card.ActionID.incrementRequiredMisses

    static func handle(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
        guard let amount = action.amount else { fatalError("Missing amount") }
        guard let targetedPlayer = action.targetedPlayer else { fatalError("Missing targetedPlayer") }

        guard let damageIndex = state.queue.firstIndex(where: {
            $0.triggeredBy.first?.name == .shoot
            && $0.name == .damage
            && $0.targetedPlayer == targetedPlayer
        }) else {
            fatalError("Missing .shoot effect on targetedPlayer")
        }

        let damageAction = state.queue[damageIndex]
        guard let requiredMisses = damageAction.requiredMisses else { fatalError("Missing requiredMisses") }

        var queue = state.queue
        queue[damageIndex] = damageAction.copy(requiredMisses: requiredMisses + amount)

        var state = state
        state.queue = queue

        return state
    }
}
