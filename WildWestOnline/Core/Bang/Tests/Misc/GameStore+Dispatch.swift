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
import Redux

func dispatchUntilCompleted(
    _ action: GameAction,
    state: GameState,
    timeout: TimeInterval = 0.1,
    file: StaticString = #file,
    line: UInt = #line
) async throws -> [GameAction] {
    let expectation = XCTestExpectation(description: "Awaiting game idle")
    expectation.isInverted = true

    let store = Store<GameState>(
        initial: state,
        reducer: GameReducer().reduce,
        middlewares: [
            Middlewares.updateGame(),
            Middlewares.logger()
        ]
    )

    var subscriptions: Set<AnyCancellable> = []
    var ocurredEvents: [GameAction] = []
    var ocurredError: Error?

    store.event.sink { event in
        if let gameAction = event as? GameAction,
           !gameAction.isPending {
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
