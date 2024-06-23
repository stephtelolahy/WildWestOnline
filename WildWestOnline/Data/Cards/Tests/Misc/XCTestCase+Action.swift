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
        let choicesWrapper = ClassWrapper(choose)
        let store = Store<GameState>(
            initial: state,
            reducer: GameState.reducer,
            middlewares: [
                Middlewares.updateGame(),
                Middlewares.choosingAgent(choicesWrapper),
                Middlewares.logger()
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
        XCTAssertEqual(choicesWrapper.value, [], "Choices must be empty", file: file, line: line)

        return (ocurredEvents, ocurredError)
    }
}

private extension Middlewares {
    static func choosingAgent(_ choices: ClassWrapper<[String]>) -> Middleware<GameState> {
        { state, _ in
            guard let chooseOne = state.chooseOne.first else {
                return nil
            }

            guard !choices.value.isEmpty else {
                fatalError("Expected a choice between \(chooseOne.value.options)")
            }

            let option = choices.value.removeFirst()
            return GameAction.choose(option, player: chooseOne.key)
        }
    }
}
