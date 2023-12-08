//
//  SimulationTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//
// swiftlint:disable no_magic_numbers

import Combine
import Game
import Inventory
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

    private func simulateGame(playersCount: Int, timeout: TimeInterval = 30.0) {
        // Given
        var game = Inventory.createGame(playersCount: playersCount)
        game.playMode = game.startOrder.reduce(into: [String: PlayMode]()) { $0[$1] = .auto }

        let expectation = XCTestExpectation(description: "Awaiting game over")
        let sut = createGameStore(initial: game) {
            expectation.fulfill()
        }
        sut.addMiddleware(AIAgentMiddleware())

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
        sut.dispatch(GameAction.setTurn(sheriff))

        // Then
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        XCTAssertNotNil(sut.state.winner, "Expected game over")
    }
}
