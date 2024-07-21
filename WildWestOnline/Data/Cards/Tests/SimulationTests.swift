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
        try XCTSkipIf(!CardsRepository().inventory.figures.contains(.custom))
        simulateGame(playersCount: 4, preferredFigure: .custom)
    }

    private func simulateGame(
        playersCount: Int,
        preferredFigure: String? = nil,
        timeout: TimeInterval = 30.0
    ) {
        // Given
        let inventory = CardsRepository().inventory
        var game = Setup.buildGame(
            playersCount: playersCount,
            inventory: inventory,
            preferredFigure: preferredFigure
        )
        game.config.playMode = game.round.startOrder.reduce(into: [String: PlayMode]()) { $0[$1] = .auto }
        let stateWrapper = ClassWrapper(game)

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
    }
}

/// Middleare reproducting state according to received event
private extension Middlewares {
    static func stateReproducer(_ prevState: ClassWrapper<GameState>) -> Middleware<GameState> {
        { state, action in
            let resultState = try! GameState.reducer(prevState.value, action)
            prevState.value = resultState
            assert(resultState.players == state.players, "🚨 Inconsistent state after applying \(action)")
            assert(resultState.field == state.field, "🚨 Inconsistent state after applying \(action)")
            assert(resultState.round == state.round, "🚨 Inconsistent state after applying \(action)")
            assert(resultState.sequence == state.sequence, "🚨 Inconsistent state after applying \(action)")
            return nil
        }
    }
}
