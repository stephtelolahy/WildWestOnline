//
//  SimulationTest.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import Testing
import Bang

struct SimulationTest {
    @Test func simulate2PlayersGame_shouldComplete() async throws {
        try await simulateGame(playersCount: 2)
    }

    private func simulateGame(playersCount: Int) async throws {
        /*
        // Given
        let inventory = CardsRepository().inventory
        var game = Setup.buildGame(
            playersCount: playersCount,
            inventory: inventory,
            preferredFigure: preferredFigure
        )
        game.playMode = game.round.startOrder.reduce(into: [String: PlayMode]()) { $0[$1] = .auto }
        let stateWrapper = StateWrapper(value: game)

        let expectation = XCTestExpectation(description: "Awaiting game over")
        let sut = Store<GameState>(
            initial: game,
            reducer: GameState.reducer,
            middlewares: [
                Middlewares.updateGame(),
                Middlewares.logger(),
                Middlewares.stateReproducer(stateWrapper)
            ]
        )

        let cancellable = sut.$state.sink { state in
            if state.sequence.winner != nil {
                expectation.fulfill()
            }
        }

        // When
        let sheriff = game.round.playOrder[0]
        sut.dispatch(GameAction.startTurn(player: sheriff))

        // Then
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        XCTAssertNotNil(sut.state.sequence.winner, "Expected game over")
        */
    }
}

/// Middleare reproducting state according to received event
private extension Middlewares {
    static func stateReproducer(_ prevState: StateWrapper) -> Middleware<GameState> {
        { state, action in
            guard let resultState = try? GameReducer().reduce(prevState.value, action) else {
                fatalError("Failed reducing \(action)")
            }

            assert(resultState == state, "🚨 Inconsistent state after applying \(action)")

            prevState.value = resultState
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
