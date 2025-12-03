//
//  IncrementCardsPerTurn.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

import CardDefinition
@testable import GameFeature

extension Card.QueueModifier {
    static let incrementCardsPerTurn = Card.QueueModifier(rawValue: "incrementCardsPerTurn")
}

struct IncrementCardsPerTurn: QueueModifierHandler {
    static let id = Card.QueueModifier.incrementCardsPerTurn

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        guard let amount = action.amount else { fatalError("Missing amount") }

        guard let actionIndex = state.queue.firstIndex(where: {
                $0.name == .drawDeck && $0.triggeredBy.first?.name == .startTurn
            }) else {
            fatalError("Missing drawDeck action")
        }

        var updatedAction = state.queue[actionIndex]
        guard case .repeat(let repeatCount) = updatedAction.selectors[0],
            case.fixed(var value) = repeatCount else {
            fatalError("Missing repeat count")
        }

        var queue = state.queue
        value += amount
        updatedAction.selectors[0] = .repeat(.fixed(value))
        queue[actionIndex] = updatedAction
        return queue
    }
}
