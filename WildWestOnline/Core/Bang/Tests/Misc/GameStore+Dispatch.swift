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
    timeout: TimeInterval = 0.1,
    file: StaticString = #file,
    line: UInt = #line
) async throws -> [GameAction] {
    let expectation = XCTestExpectation(description: "Game idle")

    let choiceHandler = StaticChoiceHandler(expectedChoices: expectedChoices)
    let store = Store<GameState>(
        initial: state,
        reducer: GameReducer().reduce,
        middlewares: [
            Middlewares.updateGame(choiceHandler: choiceHandler),
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
    await waiter.fulfillment(of: [expectation], timeout: timeout)
    subscriptions.removeAll()

    if let ocurredError {
        throw ocurredError
    }

    #expect(store.state.queue.isEmpty, "Game must be idle")
    return ocurredEvents
}

struct Choice {
    let options: [String]
    let selectionIndex: Int
}

private class StaticChoiceHandler: GameChoiceHandler {
    private var expectedChoices: [Choice]

    init(expectedChoices: [Choice]) {
        self.expectedChoices = expectedChoices
    }

    func bestMove(options: [String]) -> String {
        let choice = expectedChoices.remove(at: 0)
        assert(choice.options == options)
        return options[choice.selectionIndex]
    }
}
