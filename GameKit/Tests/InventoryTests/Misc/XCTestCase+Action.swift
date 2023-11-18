//
//  Store+Action.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Game
import XCTest
import Redux
import Combine

extension XCTestCase {

    func awaitAction(
        _ action: GameAction,
        choose: [String] = [],
        state: GameState,
        timeout: TimeInterval = 0.1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> ([GameAction], GameError?) {
        let store = createGameStore(initial: state)

        choosingAgentChoices = choose
        store.addMiddleware(choosingAgentMiddleware)

        var ocurredError: GameError?
        let expectation = XCTestExpectation(description: "Awaiting game idle")

        let cancellable = store.$state.dropFirst(1).sink { state in
            if let error = state.error {
                ocurredError = error
                expectation.fulfill()
            }
        }

        store.completed = {
            expectation.fulfill()
        }

        store.dispatch(action)

        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        XCTAssertTrue(store.state.sequence.isEmpty, "Game must be idle. sequence: \(store.state.sequence)", file: file, line: line)
        XCTAssertNil(store.state.chooseOne, "Game must be idle. chooseOne: \(String(describing: store.state.chooseOne))", file: file, line: line)
        XCTAssertTrue(choosingAgentChoices.isEmpty, "Choices must be empty. choices: \(choosingAgentChoices)", file: file, line: line)

        let events: [GameAction] = store.log.compactMap { action in
            if let event = action as? GameAction,
               event.isRenderable {
                return event
            } else {
                return nil
            }
        }

        return (events, ocurredError)
    }
}

private var choosingAgentChoices: [String] = []

private let choosingAgentMiddleware: Middleware<GameState> = { state, action in
    guard let chooseOne = state.chooseOne else {
        return nil
    }

    guard !choosingAgentChoices.isEmpty else {
        fatalError("Expected a choice between \(chooseOne.options.keys)")
    }

    let choice = choosingAgentChoices.removeFirst()
    guard let option = chooseOne.options[choice] else {
        fatalError("Expect chooseOne with option \(choice)")
    }

    return Just(option).eraseToAnyPublisher()

}
