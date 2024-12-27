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
        try await simulateGame(playersCount: 3)
    }

    private func simulateGame(playersCount: Int) async throws {
        // Given
        let deck = Setup.buildDeck(cardSets: CardSets.bang).shuffled()
        let figures = Array(Figures.bang.shuffled().prefix(playersCount))
        var state = Setup.buildGame(figures: figures, deck: deck, cards: Cards.all, defaultAbilities: DefaultAbilities.all)
        for player in state.playOrder {
            state.playMode[player] = .auto
        }

        let expectation = XCTestExpectation(description: "Game idle")
        let store = Store<GameState>(
            initial: state,
            reducer: GameReducer().reduce,
            middlewares: [
                Middlewares.logger(),
                Middlewares.updateGame,
                Middlewares.playAIMove,
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
    static func verifyState(_ prevState: StateWrapper) -> Middleware<GameState> {
        { state, action in
            DispatchQueue.main.async {
                guard let nextState = try? GameReducer().reduce(prevState.value, action) else {
                    fatalError("Failed reducing \(action)")
                }

                assert(nextState == state, "Inconsistent state after applying \(action)")

                prevState.value = nextState
            }

            return nil
        }
    }
}

private class StateWrapper: @unchecked Sendable {
    var value: GameState

    init(value: GameState) {
        self.value = value
    }
}
