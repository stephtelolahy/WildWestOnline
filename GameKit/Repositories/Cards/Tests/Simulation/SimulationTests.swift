//
//  SimulationTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//
// swiftlint:disable no_magic_numbers

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

    func xtest_simulate6PlayersGame_shouldComplete() throws {
        simulateGame(playersCount: 6)
    }

    func xtest_simulate7PlayersGame_shouldComplete() throws {
        simulateGame(playersCount: 7)
    }

    private func simulateGame(playersCount: Int, timeout: TimeInterval = 30.0) {
        // Given
        let inventory = Inventory(
            figures: CardList.figures,
            cardSets: CardSets.bang,
            cardRef: CardList.all
        )
        var game = Setup.createGame(
            playersCount: playersCount,
            inventory: inventory
        )
        game.playMode = game.startOrder.reduce(into: [String: PlayMode]()) { $0[$1] = .auto }

        let expectation = XCTestExpectation(description: "Awaiting game over")
        let sut = Store<GameState>(
            initial: game,
            reducer: GameState.reducer,
            middlewares: [
                gameLoopMiddleware(),
                StateReproducerMiddleware(initial: game),
                LoggerMiddleware()
            ]
        ) {
            expectation.fulfill()
        }

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
        sut.dispatch(GameAction.setTurn(player: sheriff))

        // Then
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        XCTAssertNotNil(sut.state.winner, "Expected game over")
    }
}

/// Middleare reproducting state according to received event
private class StateReproducerMiddleware: Middleware<GameState> {
    private var prevState: GameState

    init(initial: GameState) {
        self.prevState = initial
    }

    override func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        let resultState = GameState.reducer(prevState, action)
        prevState = resultState

        guard state == resultState else {
            fatalError("Inconsistent state after applying \(action)")
        }

        return nil
    }
}
