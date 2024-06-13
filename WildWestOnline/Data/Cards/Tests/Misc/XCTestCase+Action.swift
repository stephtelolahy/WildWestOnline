//
//  Store+Action.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Combine
import GameCore
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
        expectation.isInverted = true
        let choosingMiddleware = ChoosingAgentMiddleware(choices: choose)
        let store = Store<GameState, GameAction>(
            initial: state,
            reducer: GameState.reducer,
            middlewares: [
                updateGameMiddleware(),
                choosingMiddleware,
                LoggerMiddleware()
            ]
        )

        var ocurredError: GameError?
        var ocurredEvents: [GameAction] = []

        let cancellable = store.$state.dropFirst(1).sink { state in
            if let event = state.event {
                ocurredEvents.append(event)
            }

            if let error = state.error {
                ocurredError = error
            }
        }

        store.dispatch(action)

        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        XCTAssertEqual(store.state.sequence, [], "Game must be idle", file: file, line: line)
        XCTAssertEqual(store.state.chooseOne, [:], "Game must be idle", file: file, line: line)
        XCTAssertEqual(choosingMiddleware.choices, [], "Choices must be empty", file: file, line: line)

        return (ocurredEvents, ocurredError)
    }
}

private class ChoosingAgentMiddleware: Middleware<GameState, GameAction> {
    private(set) var choices: [String]

    init(choices: [String]) {
        self.choices = choices
        super.init()
    }

    override func handle(_ action: GameAction, state: GameState) async -> GameAction? {
        guard let chooseOne = state.chooseOne.first else {
            return nil
        }

        guard !choices.isEmpty else {
            fatalError("Expected a choice between \(chooseOne.value.options)")
        }

        let option = choices.removeFirst()
        return GameAction.choose(option, player: chooseOne.key)
    }
}
