//
//  SimulationTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import Testing
import Bang
import XCTest

struct SimulationTest {
    @Test func simulate2PlayersGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 2)
    }

    private func simulateGame(playersCount: Int) async throws {
        // Given
        let deck = Setup.buildDeck(cardSets: CardSets.bang).shuffled()
        let figures = Array(Figures.bang.shuffled().prefix(playersCount))
        let state = Setup.buildGame(figures: figures, deck: deck, cards: Cards.all)

        let expectation = XCTestExpectation(description: "Game idle")
        let store = Store<GameState>(
            initial: state,
            reducer: GameReducer().reduce,
            middlewares: [
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
            guard let pendingChoice = state.pendingChoice else {
                return nil
            }

            fatalError("Unhandled choice \(pendingChoice)")
        }
    }

    /// Middleare reproducting state according to received event
    static func verifyState(_ prevState: StateWrapper) -> Middleware<GameState> {
        { state, action in
            guard let nextState = try? GameReducer().reduce(prevState.value, action) else {
                fatalError("Failed reducing \(action)")
            }

            assert(nextState == state, "Inconsistent state after applying \(action)")

            prevState.value = nextState
            return nil
        }
    }
}

private class StateWrapper {
    var value: GameState

    init(value: GameState) {
        self.value = value
    }
}
