//
//  SimulationTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
// swiftlint:disable implicitly_unwrapped_optional

import XCTest
@testable import GameCards
import GameRules
import Combine

final class SimulationTests: XCTestCase {
    
    private var sut: Engine!
    private var cancellables = Set<AnyCancellable>()
    
    private let setup: Setup = SetupImpl()
    private let rule: Rule = RuleImpl()
    private let inventory: Inventory = InventoryImpl()
    private var updates = 0
    
    func test_Simulate5PlayersGame() {
        // Given
        // When
        let expectation = expectation(description: "game completed")
        runSimulation(playersCount: 5) {
            expectation.fulfill()
        }
        
        // Assert
        waitForExpectations(timeout: 2.0)
    }
    
    private func runSimulation(playersCount: Int, completed: @escaping () -> Void) {
        let deck = inventory.getDeck()
        let abilities = inventory.getAbilities()
        let figures = inventory.getFigures()
        let ctx = setup.createGame(playersCount: playersCount, deck: deck, abilities: abilities, figures: figures)
        sut = EngineImpl(ctx, rule: rule)
        sut.state.sink { [self] in
            
            if $0.isOver {
                completed()
            }
            
            updates += 1
            print("\n#\(updates) event=\($0.event != nil ? String(describing: $0.event!) : "nil") queue=\(sut.queue.count)")
            
            // choose random move
            if case let .success(event) = $0.event {
                var moves: [Move] = []
                if let activate = event as? Activate {
                    moves = activate.moves
                }
                if let chooseOne = event as? ChooseOne {
                    moves = chooseOne.options
                }
                
                if let best = moves.randomElement() {
                    DispatchQueue.main.async {
                        self.sut.input(best)
                    }
                }
                
            }
        }
        .store(in: &cancellables)
        
        sut.start()
        sut.update()
    }
    
    private func printEvent(_ event: Result<Event, GameError>) {
        print(event)
    }
    
}
