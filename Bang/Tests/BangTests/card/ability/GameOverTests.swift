//
//  GameOverTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class GameOverTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_EndGame_OnEliminated() {
        // Given
        let c1 = inventory.getCard("gameOver", withId: "c1")
        let p1 = PlayerImpl(abilities: [c1])
        let p2 = PlayerImpl(abilities: [c1])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2])
        let sut = EngineImpl(ctx, queue: [Eliminate(player: PlayerId("p1")).asNode()])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Eliminate(player: PlayerId("p1"))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(EndGame())
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
