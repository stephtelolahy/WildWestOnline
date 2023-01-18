//
//  BarrelTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
// swiftlint:disable identifier_name

import XCTest
import Bang

final class BarrelTests: XCTestCase {

    private let inventory: Inventory = InventoryImpl()

    func test_PlayingBarrel() throws {
        // Given
        let c1 = inventory.getCard(.barrel, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [.success(Play(actor: "p1", card: "c1"))])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
