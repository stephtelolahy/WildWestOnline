//
//  HealTests.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

import XCTest
import Bang

final class HealTests: XCTestCase {
    
    private lazy var sut: EffectResolver = EffectResolverImpl()

    func test_Gain1LifePoint_IfDamaged() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 2)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let effect: Effect = .heal(player: "p1", value: 1)
        
        // When
        let result = sut.resolve(effect, ctx: ctx)
        
        // assert
        try assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.health, 3)
            XCTAssertNil($0.effects)
        }
    }
    
    func test_Gain2LifePoints_IfDamaged() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 2)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let effect: Effect = .heal(player: "p1", value: 2)
        
        // When
        let result = sut.resolve(effect, ctx: ctx)
        
        // assert
        try assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.health, 4)
            XCTAssertNil($0.effects)
        }
    }
    
    func test_DoNotGainLifePoint_IfMaxHealth() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 4)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let effect: Effect = .heal(player: "p1", value: 1)
        
        // When
        let result = sut.resolve(effect, ctx: ctx)
        
        // assert
        try assertIsFailure(result) {
            XCTAssertEqual($0, .playerAlreadyMaxHealth("p1"))
        }
    }
    
    func test_GainLifePointsTillMaxHealth() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 3)
        let ctx: Game = GameImpl(players: ["p1": p1])
        let effect: Effect = .heal(player: "p1", value: 2)
        
        // When
        let result = sut.resolve(effect, ctx: ctx)
        
        // assert
        try assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.health, 4)
            XCTAssertNil($0.effects)
        }
    }
}
