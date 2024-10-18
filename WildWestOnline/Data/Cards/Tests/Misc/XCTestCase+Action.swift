//
//  Store+Action.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Combine
import GameCore
import Redux
import Testing
import Foundation
import XCTest

func dispatch(
    _ action: GameAction,
    state: GameState,
    choose: [String] = [],
    timeout: TimeInterval = 0.1,
    file: StaticString = #file,
    line: UInt = #line
) async throws -> [GameAction] {
    let expectation = XCTestExpectation(description: "Awaiting game idle")
    expectation.isInverted = true
    let choicesWrapper = ChoiceWrapper(value: choose)
    let store = Store<GameState>(
        initial: state,
        reducer: GameState.reducer,
        middlewares: [
            Middlewares.updateGame(),
            Middlewares.choosingAgent(choicesWrapper),
            Middlewares.logger()
        ]
    )

    var subscriptions: Set<AnyCancellable> = []
    var ocurredEvents: [GameAction] = []
    var ocurredError: Error?

    store.event.sink { event in
        if let gameAction = event as? GameAction,
           gameAction.isRenderable {
            ocurredEvents.append(gameAction)
        }
    }.store(in: &subscriptions)

    store.error.sink { error in
        ocurredError = error
    }.store(in: &subscriptions)

    store.dispatch(action)

    let waiter = XCTWaiter()
    await waiter.fulfillment(of: [expectation], timeout: timeout)
    subscriptions.removeAll()

    if let ocurredError {
        throw ocurredError
    }

    #expect(store.state.queue.isEmpty, "Game must be idle")
    #expect(store.state.chooseOne.isEmpty, "Game must be idle")
    #expect(choicesWrapper.value.isEmpty, "Choices must be empty")

    return ocurredEvents
}

private class ChoiceWrapper {
    var value: [String]

    init(value: [String]) {
        self.value = value
    }
}

private extension Middlewares {
    static func choosingAgent(_ choices: ChoiceWrapper) -> Middleware<GameState> {
        { state, _ in
            guard let chooseOne = state.chooseOne.first else {
                return Empty().eraseToAnyPublisher()
            }
            
            guard !choices.value.isEmpty else {
                fatalError("Expected a choice between \(chooseOne.value.options)")
            }

            let option = choices.value.removeFirst()
            return Just(GameAction.prepareChoose(option, player: chooseOne.key)).eraseToAnyPublisher()
        }
    }
}
