//
//  HealTests.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//
// swiftlint:disable: identifier_name

import XCTest
import Bang

final class HealTests: XCTestCase {
    
    func test_Gain1LifePoint_IfHeal() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 2)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Heal(player: PlayerId("p1"), value: 1)
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").health, 3)
        }
    }
    
    func test_Gain2LifePoints_IfHeal() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 2)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Heal(player: PlayerId("p1"), value: 2)
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").health, 4)
        }
    }
    
    func test_Gain1LifePoint_IfLimitedByMaxHealth() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 3)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Heal(player: PlayerId("p1"), value: 2)
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").health, 4)
        }
    }
    
    func test_ThrowError_IfAlreadyMaxHealth() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 4)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Heal(player: PlayerId("p1"), value: 1)
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: .playerAlreadyMaxHealth("p1"))
    }
}
