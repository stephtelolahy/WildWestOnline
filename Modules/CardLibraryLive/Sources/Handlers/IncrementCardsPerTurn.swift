//
//  IncrementCardsPerTurn.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//

@testable import GameCore

extension Card.ActionID {
    static let incrementCardsPerTurn = Card.ActionID(rawValue: "incrementCardsPerTurn")
}

public extension GameFeature.Action {
    static func incrementCardsPerTurn(_ amount: Int) -> Self {
        .init(
            actionID: .incrementCardsPerTurn,
            amount: amount
        )
    }
}

struct IncrementCardsPerTurn: GameActionHandler {
    static let id = Card.ActionID.incrementCardsPerTurn

    static func handle(_ action: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> GameFeature.State {
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

        var state = state
        state.queue = queue

        return state
    }
}
