//
//  SaloonTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameRules

final class SaloonTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    private let rule: EngineRule = EngineRuleImpl()
    
    func test_AllDamagedPlayersGainHealth_IfPlayingSaloon() throws {
        // Given
        let c1 = inventory.getCard(.saloon, withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 1, hand: [c1])
        let p2 = PlayerImpl(maxHealth: 3, health: 2)
        let p3 = PlayerImpl(maxHealth: 3, health: 3)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p3", "p1", "p2"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "c1")),
                .success(Heal(player: PlayerId("p1"), value: 1)),
                .success(Heal(player: PlayerId("p2"), value: 1))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_CannotPlaySaloon_IfAllPlayersMaxHealth() throws {
        // Given
        let c1 = inventory.getCard(.saloon, withId: "c1")
        let p1 = PlayerImpl(maxHealth: 4, health: 4, hand: [c1])
        let p2 = PlayerImpl(maxHealth: 3, health: 3)
        let p3 = PlayerImpl(maxHealth: 3, health: 3)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p3", "p1", "p2"])
        let sut = EngineImpl(ctx, rule: rule)
        
        createExpectation(
            engine: sut,
            expected: [.error(GameError.noPlayerDamaged)])
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
