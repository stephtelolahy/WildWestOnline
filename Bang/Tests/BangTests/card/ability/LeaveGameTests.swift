//
//  LeaveGameTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import Bang

final class LeaveGameTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_Eliminate_OnLoosingLastHealth() {
        // Given
        let c1 = inventory.getCard(.leaveGame, withId: "c1")
        let p1 = PlayerImpl(health: 1, abilities: [c1])
        let p2 = PlayerImpl(abilities: [c1])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2])
        let sut = EngineImpl(ctx, queue: [Damage(player: PlayerId("p1"), value: 1)])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Damage(player: PlayerId("p1"), value: 1)),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Eliminate(player: PlayerId("p1")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
