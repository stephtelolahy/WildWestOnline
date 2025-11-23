//
//  IncrementCardsPerTurnModifier.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

@testable import GameFeature

extension GameFeature.Action.QueueModifier {
    static let incrementCardsPerTurn = GameFeature.Action.QueueModifier(rawValue: "incrementCardsPerTurn")
}

struct IncrementCardsPerTurnModifier: QueueModifierHandler {
    static let id = GameFeature.Action.QueueModifier.incrementCardsPerTurn

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        guard let amount = action.amount else { fatalError("Missing amount") }

        guard let actionIndex = state.queue.firstIndex(where: {
                $0.name == .drawDeck && $0.triggeredBy.first?.name == .startTurn
            }) else {
            fatalError("Missing drawDeck action")
        }

        var updatedAction = state.queue[actionIndex]
        guard case .repeat(let repeatCount) = updatedAction.selectors[0],
            case.fixed(let value) = repeatCount else {
            fatalError("missing repeat count")
        }

        var queue = state.queue
        let count = value + amount
        updatedAction.selectors[0] = .repeat(.fixed(count))
        queue[actionIndex] = updatedAction
        return queue
    }
}
