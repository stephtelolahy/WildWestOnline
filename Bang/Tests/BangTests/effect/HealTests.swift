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
    
    private let sut: EffectResolver = EffectResolverMain()
    
    func test_Gain1LifePoint_IfDamaged() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 2)
        let ctx: Game = GameImpl(players: ["p1": p1])
        
        // When
        let result = sut.resolve(.heal(player: .id("p1"), value: 1), ctx: ctx)
        
        // assert
        assertIsSuccess(result) {
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
        
        // When
        let result = sut.resolve(.heal(player: .id("p1"), value: 2), ctx: ctx)
        
        // assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.health, 4)
            XCTAssertNil($0.effects)
        }
    }
    
    func test_Gain1LifePoint_IfLimitedByMaxHealth() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 3)
        let ctx: Game = GameImpl(players: ["p1": p1])
        
        // When
        let result = sut.resolve(.heal(player: .id("p1"), value: 2), ctx: ctx)
        
        // assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.health, 4)
            XCTAssertNil($0.effects)
        }
    }
    
    func test_ThrowError_IfAlreadyMaxHealth() throws {
        // Given
        let p1: Player = PlayerImpl(maxHealth: 4, health: 4)
        let ctx: Game = GameImpl(players: ["p1": p1])
        
        // When
        let result = sut.resolve(.heal(player: .id("p1"), value: 1), ctx: ctx)
        
        // assert
        assertIsFailure(result, equalTo: .playerAlreadyMaxHealth("p1"))
    }
}
