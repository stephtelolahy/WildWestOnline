//
//  GameStore+Dispatch.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Testing
import XCTest
import Combine
import Bang

func dispatchUntilCompleted(
    _ action: GameAction,
    state: GameState,
    expectedChoices: [Choice] = [],
    file: StaticString = #file,
    line: UInt = #line
) async throws -> [GameAction] {
    let expectation = XCTestExpectation(description: "Game idle")

    let store = Store<GameState>(
        initial: state,
        reducer: GameReducer().reduce,
        middlewares: [
            Middlewares.updateGame,
            Middlewares.handlePendingChoice(choicesWrapper: .init(choices: expectedChoices)),
            Middlewares.logger()
        ]
    ) {
        expectation.fulfill()
    }

    var subscriptions: Set<AnyCancellable> = []
    var ocurredEvents: [GameAction] = []
    var ocurredError: Error?

    store.event.sink { event in
        if let gameAction = event as? GameAction,
           gameAction.payload.selectors.isEmpty {
            ocurredEvents.append(gameAction)
        }
    }
    .store(in: &subscriptions)

    store.error.sink { error in
        ocurredError = error
    }
    .store(in: &subscriptions)

    store.dispatch(action)

    let waiter = XCTWaiter()
    await waiter.fulfillment(of: [expectation])
    subscriptions.removeAll()

    if let ocurredError {
        throw ocurredError
    }

    return ocurredEvents
}

struct Choice {
    let options: [String]
    let selectionIndex: Int
}

private class ChoicesWrapper {
    var choices: [Choice]

    init(choices: [Choice]) {
        self.choices = choices
    }
}

private extension Middlewares {
    static func handlePendingChoice(choicesWrapper: ChoicesWrapper) -> Middleware<GameState> {
        { state, _ in
            guard let pendingChoice = state.pendingChoice else {
                return nil
            }

            let expectedChoice = choicesWrapper.choices.remove(at: 0)

            guard pendingChoice.options.map(\.label) == expectedChoice.options else {
                fatalError("Unexpected choice: \(pendingChoice)")
            }

            let selection = pendingChoice.options[expectedChoice.selectionIndex]
            let chooseAction = GameAction.choose(selection.label, player: pendingChoice.chooser)
            return Just(chooseAction).eraseToAnyPublisher()
        }
    }
}
