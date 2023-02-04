//
//  MissedTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore

final class MissedTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_CannotPlayMissed_NoPlaymode() throws {
        // Given
        let c1 = inventory.getCard(.missed, withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1])
        let sut = EngineImpl(ctx, rule: rule)
                        
                        createExpectation(
                            engine: sut,
                            expected: [.error(EngineError.cannotPlayThisCard)])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
