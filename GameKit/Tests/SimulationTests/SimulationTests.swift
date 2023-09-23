//
//  SimulationTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/06/2023.
//

import XCTest
import Game
import Combine
import Inventory

final class SimulationTests: XCTestCase {

    func testSimulations() {
        for index in 1...2 {
            let playersCount = Int.random(in: 4...7)
            print("🏁 Simulation #\(index) playersCount: \(playersCount)")
            simulateGame(playersCount: playersCount)
        }
    }

    private func simulateGame(playersCount: Int) {
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
        
        // When
        let sheriff = game.playOrder[0]
        sut.dispatch(GameAction.setTurn(sheriff))

        // Then
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
