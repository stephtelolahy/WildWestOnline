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

    func testMultipleSimulations() {
        for index in 1...5 {
            let playersCount = Int.random(in: 4...7)
            print("🏁 Simulation #\(index) playersCount: \(playersCount)")
            simulateGame(playersCount: playersCount)
        }
    }
    
    private func simulateGame(playersCount: Int) {
        // Given
        let game = Inventory.createGame(playersCount: playersCount)
        
        let sut = createGameStore(initial: game)
        
        let expectation = XCTestExpectation(description: "Awaiting game over")
        let cancellable = sut.$state.sink { state in
            if state.isOver != nil {
                expectation.fulfill()
            }
            
            if let active = state.active {
                // swiftlint:disable:next force_unwrapping
                let randomCard = active.cards.randomElement()!
                let randomAction = GameAction.play(randomCard, actor: active.player)
                DispatchQueue.main.async {
                    sut.dispatch(randomAction)
                }
            }
            
            if let chooseOne = state.chooseOne {
                // swiftlint:disable:next force_unwrapping
                let randomAction = chooseOne.options.values.randomElement()!
                DispatchQueue.main.async {
                    sut.dispatch(randomAction)
                }
            }
        }
        
        // When
        let sheriff = game.playOrder[0]
        sut.dispatch(.setTurn(sheriff))
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
