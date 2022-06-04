//
//  SimulationTests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import XCTest
import Combine
import CardGameCore
import CardGameMechanics

class SimulationTests: XCTestCase {
    
    private var sut: Game!
    private let ai = RandomAI()
    private var cancellables: [Cancellable] = []
    
    func test_Simulate2PlayersGame() {
        // Given
        // When
        let expectation = XCTestExpectation(description: "Game should complete")
        runSimulation(playersCount: 2) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
    }
    
    private func runSimulation(playersCount: Int, completed: @escaping () -> Void) {
        let deck = Setup.buildDeck(uniqueCards: Cards.playable, cardSets: CardSets.all)
        let state = Setup.buildGame(playersCount: playersCount, deck: deck, inner: Cards.inner)
        sut = Game(state)
        cancellables.append(sut.state.sink {
            if $0.isGameOver {
                completed()
            }
        })
        
        sut.loopUpdate()
        ai.observe(game: sut)
    }
}
