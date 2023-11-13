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
        for index in 1...10 {
            let playersCount = Int.random(in: 4...7)
            print("🏁 Simulation #\(index) playersCount: \(playersCount)")
            simulateGame(playersCount: playersCount, index: index)
        }
    }

    private func simulateGame(playersCount: Int, index: Int) {
        // Given
        let game = Inventory.createGame(playersCount: playersCount)

        let sut = createGameStore(initial: game)
        sut.addMiddleware(aiAgentMiddleware)

        let expectation = XCTestExpectation(description: "Awaiting game over")
        let cancellable = sut.$state.sink { state in

            if case .eliminate = state.event {
                print("🏁 Simulation #\(index) playersCount: \(state.playOrder.count)/\(state.startOrder.count)")
            }

            if state.isOver != nil {
                print("🏁 Simulation #\(index) Completed!")
                expectation.fulfill()
            }

            if let error = state.error {
                XCTFail("Unexpected error \(error) on \(state.failed!)")
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
