//
//  Store+Action.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Game
import XCTest
import Redux

extension XCTestCase {

    func awaitAction(
        _ action: GameAction,
        choices: [String] = [],
        state: GameState,
        continueOnQueueEmpty: Bool = true,
        timeout: TimeInterval = 0.1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> ([GameAction], GameError?) {
        let store = createGameStore(initial: state)
        var choices = choices
        var events: [GameAction] = []
        var ocurredError: GameError?
        let expectation = XCTestExpectation(description: "Awaiting game idle")
        if continueOnQueueEmpty {
            expectation.isInverted = true
        }

        let cancellable = store.$state.dropFirst(1).sink { state in
            if let event = state.event,
               event.isRenderable {
                events.append(event)
            }

            if let error = state.error {
                ocurredError = error
                expectation.fulfill()
            }

            if let chooseOne = state.chooseOne {
                guard !choices.isEmpty else {
                    XCTFail("Expected a choice between \(chooseOne.options.keys)", file: file, line: line)
                    return
                }

                let choice = choices.removeFirst()
                guard let option = chooseOne.options[choice] else {
                    XCTFail("Expect chooseOne with option \(choice)", file: file, line: line)
                    return
                }

                DispatchQueue.main.async {
                    store.dispatch(option)
                }
                return
            }

            if !continueOnQueueEmpty,
               state.queue.isEmpty {
                expectation.fulfill()
            }
        }

        store.dispatch(action)

        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        XCTAssertTrue(store.state.queue.isEmpty, "Game must be idle", file: file, line: line)
        XCTAssertNil(store.state.chooseOne, "Game must be idle", file: file, line: line)

        return (events, ocurredError)
    }
}
