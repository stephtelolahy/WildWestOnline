//
//  Store+Action.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Combine
import Game
import Redux
import XCTest

extension XCTestCase {
    func awaitAction(
        _ action: GameAction,
        state: GameState,
        choose: [String] = [],
        timeout: TimeInterval = 0.1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> ([GameAction], GameError?) {
        let expectation = XCTestExpectation(description: "Awaiting game idle")
        let store = createGameStore(initial: state) {
            expectation.fulfill()
        }

        let choosingMiddleware = ChoosingAgentMiddleware(choices: choose)
        store.addMiddleware(choosingMiddleware)

        var ocurredError: GameError?

        let cancellable = store.$state.dropFirst(1).sink { state in
            if let error = state.error {
                ocurredError = error
                expectation.fulfill()
            }
        }

        store.dispatch(action)

        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        XCTAssertEqual(store.state.sequence, [], "Game must be idle", file: file, line: line)
        XCTAssertEqual(store.state.chooseOne, [:], "Game must be idle", file: file, line: line)
        XCTAssertEqual(choosingMiddleware.choices, [], "Choices must be empty", file: file, line: line)

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

private class ChoosingAgentMiddleware: Middleware<GameState> {
    private(set) var choices: [String]

    init(choices: [String]) {
        self.choices = choices
        super.init()
    }

    override func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        guard let chooseOne = state.chooseOne.first else {
            return nil
        }

        guard !choices.isEmpty else {
            fatalError("Expected a choice between \(chooseOne.value.keys)")
        }

        let choice = choices.removeFirst()
        guard let option = chooseOne.value[choice] else {
            fatalError("Expect chooseOne with option \(choice)")
        }

        return Just(option).eraseToAnyPublisher()
    }
}
