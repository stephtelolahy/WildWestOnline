//
//  GameStore+Dispatch.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Testing
import XCTest
import Redux
import Combine
import GameCore

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
            Middlewares.performChoices(.init(choices: expectedChoices))
        ]
    ) {
        expectation.fulfill()
    }

    var subscriptions: Set<AnyCancellable> = []
    var ocurredEvents: [GameAction] = []
    var ocurredError: Error?

    store.eventPublisher.sink { event in
        if let gameAction = event as? GameAction,
           gameAction.isRenderable {
            ocurredEvents.append(gameAction)
        }
    }
    .store(in: &subscriptions)

    store.errorPublisher.sink { error in
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
    static func performChoices(_ expectedChoicesWrapper: ChoicesWrapper) -> Middleware<GameState> {
        { state, _ in
            guard let pendingChoice = state.pendingChoice else {
                return nil
            }

            guard expectedChoicesWrapper.choices.isNotEmpty else {
                fatalError("Unexpected choice: \(pendingChoice)")
            }

            guard pendingChoice.options.map(\.label) == expectedChoicesWrapper.choices[0].options else {
                fatalError("Unexpected options: \(pendingChoice.options.map(\.label)) expected: \(expectedChoicesWrapper.choices[0].options)")
            }

            let expectedChoice = expectedChoicesWrapper.choices.remove(at: 0)
            let selection = pendingChoice.options[expectedChoice.selectionIndex]
            return GameAction.choose(selection.label, player: pendingChoice.chooser)
        }
    }
}
