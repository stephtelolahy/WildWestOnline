//
//  SimulationTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import CardsRepository
import Combine
import GameCore
import Redux
import XCTest

final class SimulationTests: XCTestCase {
    func test_simulate4PlayersGame_shouldComplete() throws {
        simulateGame(playersCount: 4)
    }

    func test_simulate5PlayersGame_shouldComplete() throws {
        simulateGame(playersCount: 5)
    }

    func test_simulate6PlayersGame_shouldComplete() throws {
        simulateGame(playersCount: 6)
    }

    func test_simulate7PlayersGame_shouldComplete() throws {
        simulateGame(playersCount: 7)
    }

    func test_simulateGameWithCustomFigure_shouldComplete() throws {
        simulateGame(playersCount: 4, preferredFigure: .custom)
    }

    private func simulateGame(
        playersCount: Int,
        preferredFigure: String? = nil,
        timeout: TimeInterval = 30.0
    ) {
        // Given
        let inventory = CardsRepository().inventory
        var game = Setup.createGame(
            playersCount: playersCount,
            inventory: inventory,
            preferredFigure: preferredFigure
        )
        game.playMode = game.startOrder.reduce(into: [String: PlayMode]()) { $0[$1] = .auto }

        let expectation = XCTestExpectation(description: "Awaiting game over")
        let sut = StoreV1<GameState>(
            initial: game,
            reducer: GameState.reducer,
            middlewares: [
                updateGameMiddleware(),
                LoggerMiddleware(),
                StateReproducerMiddleware(initial: game)
            ]
        )

        let cancellable = sut.$state.sink { state in
            if state.winner != nil {
                expectation.fulfill()
            }

            if let error = state.error {
                XCTFail("Unexpected error \(error)")
            }
        }

        // When
        let sheriff = game.playOrder[0]
        sut.dispatch(GameAction.startTurn(player: sheriff))

        // Then
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        XCTAssertNotNil(sut.state.winner, "Expected game over")
    }
}

/// Middleare reproducting state according to received event
private class StateReproducerMiddleware: MiddlewareV1<GameState> {
    private var prevState: GameState

    init(initial: GameState) {
        self.prevState = initial
    }

    override func effect(on action: ActionV1, state: GameState) async -> ActionV1? {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            let resultState = GameState.reducer(self.prevState, action)
            self.prevState = resultState
            if !resultState.isEqualIgnoringSequence(to: state) {
                assertionFailure("🚨 Inconsistent state after applying \(action)")
            }
        }
        return nil
    }
}

private extension GameState {
    func isEqualIgnoringSequence(to anotherState: GameState) -> Bool {
        var state = self
        state.sequence = []
        var anotherState = anotherState
        anotherState.sequence = []

        return state == anotherState
    }
}