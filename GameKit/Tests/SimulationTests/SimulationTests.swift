//
//  SimulationTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

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
        let game = Inventory.createGame(playersCount: playersCount)
        let sut = createGameStore(initial: game)
        sut.addMiddleware(aiAgentMiddleware)
        let expectation = XCTestExpectation(description: "Awaiting game over")

        let cancellable = sut.$state.sink { state in
            if state.isOver != nil {
                expectation.fulfill()
            }

            if let error = state.error {
                XCTFail("Unexpected error \(error)")
            }
        }

        sut.completed = {
            XCTAssertNotNil(sut.state.isOver, "Expected game over")
            expectation.fulfill()
        }

        // When
        let sheriff = game.playOrder[0]
        sut.dispatch(GameAction.setTurn(sheriff))

        // Then
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
    }
}
