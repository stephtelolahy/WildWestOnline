//
//  DamageTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class DamageTests: XCTestCase {
    
    func test_Loose1LifePoint_IfDamaged() throws {
        // Given
        let p1: Player = PlayerImpl(health: 3)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Damage(player: PlayerId("p1"), value: 1)
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").health, 2)
        }
    }
    
    func test_Loose2LifePoints_IfDamaged() throws {
        // Given
        let p1: Player = PlayerImpl(health: 3)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Damage(player: PlayerId("p1"), value: 2)
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").health, 1)
        }
    }
}
