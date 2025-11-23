//
//  IncrementCardsPerTurnModifier.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

@testable import GameFeature

extension GameFeature.Action.Modifier {
    static let incrementCardsPerTurn = GameFeature.Action.Modifier(rawValue: "incrementCardsPerTurn")
}

struct IncrementCardsPerTurnModifier: ModifierHandler {
    static let id = GameFeature.Action.Modifier.incrementCardsPerTurn

    static func apply(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
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

        var state = state
        let count = value + amount
        updatedAction.selectors[0] = .repeat(.fixed(count))
        state.queue[actionIndex] = updatedAction

        return state
    }
}
