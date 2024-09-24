//
//  SimulationTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import CardsData
import Combine
import GameCore
import Redux
import Testing
import Foundation
import XCTest

struct SimulationTests {
    @Test func simulate4PlayersGame_shouldComplete() async throws {
        await simulateGame(playersCount: 4)
    }

    @Test func simulate7PlayersGame_shouldComplete() async throws {
        await simulateGame(playersCount: 7)
    }

    @Test(.enabled(if: CardsRepository().inventory.figures.contains(.custom)))
    func simulateGameWithCustomFigure_shouldComplete() async throws {
        await simulateGame(playersCount: 4, preferredFigure: .custom)
    }

    private func simulateGame(
        playersCount: Int,
        preferredFigure: String? = nil,
        timeout: TimeInterval = 5.0
    ) async {
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
        let waiter = XCTWaiter()
        await waiter.fulfillment(of: [expectation], timeout: timeout)
        cancellable.cancel()
        #expect(sut.state.sequence.winner != nil, "Expected game over")
    }
}

/// Middleare reproducting state according to received event
private extension Middlewares {
    static func stateReproducer(_ prevState: StateWrapper) -> Middleware<GameState> {
        { state, action in
            let resultState = try! GameState.reducer(prevState.value, action)
            prevState.value = resultState
            assert(resultState.players == state.players, "🚨 Inconsistent state after applying \(action)")
            assert(resultState.field == state.field, "🚨 Inconsistent state after applying \(action)")
            assert(resultState.round == state.round, "🚨 Inconsistent state after applying \(action)")
            assert(resultState.sequence == state.sequence, "🚨 Inconsistent state after applying \(action)")
            return Empty().eraseToAnyPublisher()
        }
    }
}

private class StateWrapper {
    var value: GameState

    init(value: GameState) {
        self.value = value
    }
}
