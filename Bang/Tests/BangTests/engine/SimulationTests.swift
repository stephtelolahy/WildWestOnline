//
//  SimulationTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
// swiftlint:disable implicitly_unwrapped_optional

import XCTest
import Bang
import Combine

final class SimulationTests: XCTestCase {
    
    private var sut: Engine!
    private var cancellables = Set<AnyCancellable>()
    
    private let setup: Setup = SetupImpl()
    private let inventory: Inventory = InventoryImpl()
    private let aiAgent: AIAgent = AIAgentImpl(strategy: AIStrategyRandom())
    private var updates = 0
    
    func test_Simulate2PlayersGame() {
        // Given
        // When
        let expectation = expectation(description: "game completed")
        runSimulation(playersCount: 2) {
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    private func runSimulation(playersCount: Int, completed: @escaping () -> Void) {
        let deck = inventory.getDeck()
        let abilities = inventory.getAbilities()
        let ctx = setup.createGame(playersCount: playersCount, deck: deck, abilities: abilities)
        sut = EngineImpl(ctx)
        aiAgent.playAny(sut)
        sut.state.sink { [self] in
            
            updates += 1
            print("#\(updates)")
            
            if $0.isOver {
                completed()
            }
            
            if let event = $0.event {
                printEvent(event)
            }
        }
        .store(in: &cancellables)
        
        sut.start()
        sut.update()
    }
    
    private func printEvent(_ event: Result<Effect, GameError>) {
        print(event)
    }
    
}
