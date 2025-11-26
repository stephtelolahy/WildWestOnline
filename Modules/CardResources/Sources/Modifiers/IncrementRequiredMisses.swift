//
//  IncrementCardsPerTurn.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

@testable import GameFeature

extension GameFeature.Action.QueueModifier {
    static let incrementRequiredMisses = GameFeature.Action.QueueModifier(rawValue: "incrementRequiredMisses")
}

struct IncrementRequiredMisses: QueueModifierHandler {
    static let id = GameFeature.Action.QueueModifier.incrementRequiredMisses

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        guard let amount = action.amount else { fatalError("Missing amount") }

        guard let damageIndex = state.queue.firstIndex(where: {
            $0.triggeredBy.first?.name == .shoot
            && $0.name == .damage
            && $0.targetedPlayer == action.targetedPlayer
        }) else {
            fatalError("Missing .shoot effect on targetedPlayer")
        }

        let damageAction = state.queue[damageIndex]
        guard let requiredMisses = damageAction.requiredMisses else { fatalError("Missing requiredMisses") }

        var queue = state.queue
        queue[damageIndex] = damageAction.copy(requiredMisses: requiredMisses + amount)
        return queue
    }
}
