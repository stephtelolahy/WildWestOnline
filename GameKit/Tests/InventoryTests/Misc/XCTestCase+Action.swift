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
        choose: [String] = [],
        state: GameState,
        timeout: TimeInterval = 0.1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> ([GameAction], GameError?) {
        let store = createGameStore(initial: state)
        var choices = choose
        var ocurredError: GameError?
        let expectation = XCTestExpectation(description: "Awaiting game idle")

        store.completed = {
            expectation.fulfill()
        }

        let cancellable = store.$state.dropFirst(1).sink { state in
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
        }

        store.dispatch(action)

        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        XCTAssertTrue(store.state.sequence.isEmpty, "Game must be idle. sequence: \(store.state.sequence)", file: file, line: line)
        XCTAssertNil(store.state.chooseOne, "Game must be idle. chooseOne: \(String(describing: store.state.chooseOne))", file: file, line: line)
        XCTAssertTrue(choices.isEmpty, "Choices must be empty. choices: \(choices)", file: file, line: line)

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
