//
//  GameOverTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class GameOverTests: XCTestCase {
    
    // TODO: real game over rules
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_EndGame_IfOnePlayerLast() {
        // Given
        let c1 = inventory.getCard(.gameOver, withId: "c1")
        let p1 = PlayerImpl(abilities: [c1])
        let p2 = PlayerImpl(abilities: [c1])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2"])
        let sut = EngineImpl(ctx, queue: [Eliminate(player: PlayerId("p1"))], rule: rule)
        
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
    
    func test_DoNotEndGame_IfTwoPlayersLast() {
        // Given
        let c1 = inventory.getCard(.gameOver, withId: "c1")
        let p1 = PlayerImpl(abilities: [c1])
        let p2 = PlayerImpl(abilities: [c1])
        let p3 = PlayerImpl(abilities: [c1])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p2", "p3"])
        let sut = EngineImpl(ctx, queue: [Eliminate(player: PlayerId("p1"))], rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [.success(Eliminate(player: PlayerId("p1")))])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
