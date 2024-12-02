//
//  SimulationTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import Testing
import Bang
import XCTest
import Combine

struct SimulationTest {
    @Test func simulate2PlayersGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 2)
    }

    private func simulateGame(playersCount: Int) async throws {
        // Given
        let deck = Setup.buildDeck(cardSets: CardSets.bang).shuffled()
        let figures = Array(Figures.bang.shuffled().prefix(playersCount))
        let state = Setup.buildGame(figures: figures, deck: deck, cards: Cards.all, defaultAbilities: DefaultAbilities.all)

        let expectation = XCTestExpectation(description: "Game idle")
        let store = Store<GameState>(
            initial: state,
            reducer: GameReducer().reduce,
            middlewares: [
                Middlewares.logger(),
                Middlewares.updateGame,
                Middlewares.handlePendingChoice,
                Middlewares.verifyState(StateWrapper(value: state))
            ]
        ) {
            expectation.fulfill()
        }

        // When
        let startAction = GameAction.startTurn(player: state.playOrder[0])
        store.dispatch(startAction)

        // Then
        let waiter = XCTWaiter()
        await waiter.fulfillment(of: [expectation])

        #expect(store.state.isOver, "Expected game over")
    }
}

private extension Middlewares {
    static var handlePendingChoice: Middleware<GameState> {
        { state, _ in
            Deferred {
                Future<Action?, Never> { promise in
                    let output = _handlePendingChoice(state: state)
                    promise(.success(output))
                }
            }
            .eraseToAnyPublisher()
        }
    }

    private static func _handlePendingChoice(state: GameState) -> Action? {
        if let pendingChoice = state.pendingChoice,
           let selection = pendingChoice.options.randomElement() {
            return GameAction.choose(selection.label, player: pendingChoice.chooser)
        }

        if state.active.isNotEmpty,
           let choice = state.active.first,
           let selection = choice.value.randomElement() {
            return GameAction.play(selection, player: choice.key)
        }

        return nil
    }

    /// Middleare reproducting state according to received event
    static func verifyState(_ prevState: StateWrapper) -> Middleware<GameState> {
        { state, action in
            Deferred {
                Future<Action?, Never> { promise in
                    _verifyState(prevState, action: action, state: state)
                    promise(.success(nil))
                }
            }
            .eraseToAnyPublisher()
        }
    }

    private static func _verifyState(_ prevState: StateWrapper, action: Action, state: GameState) {
        guard let nextState = try? GameReducer().reduce(prevState.value, action) else {
            fatalError("Failed reducing \(action)")
        }

        assert(nextState == state, "Inconsistent state after applying \(action)")

        prevState.value = nextState
    }
}

private class StateWrapper {
    var value: GameState

    init(value: GameState) {
        self.value = value
    }
}
