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
    private var cancellables = Set<AnyCancellable>()
    private var moves = 0
    
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
        let state = Setup.buildGame(playersCount: playersCount, deck: Cards.getDeck(), inner: Cards.getAll(type: .inner))
        sut = Game(state)
        sut.state.sink { [weak self] in
            if $0.isOver {
                completed()
            }
            
            if let message = $0.event {
                self?.printEvent(message)
            }
        }.store(in: &cancellables)
        
        sut.loopUpdate()
        ai.observe(game: sut)
    }
    
    private func printEvent(_ event: Event) {
        if event is Move {
            moves += 1
            print("\(moves)\t\(String(describing: event))")
        } else {
            print("\t\(String(describing: event))")
        }
    }
}
