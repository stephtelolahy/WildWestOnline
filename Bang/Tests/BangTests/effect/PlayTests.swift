//
//  PlayTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class PlayTests: XCTestCase {
    
    func test_DiscardImmediately_IfPlayed() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), [])
            XCTAssertEqual(ctx.discard.map(\.id), ["c1"])
        }
    }
    
    func test_OutputCardEffects_IfPlayed() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let children: [Effect] = try XCTUnwrap($0.effects)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], Dummy())
        }
    }
    
    func test_ThrowsError_IfAnyRequirementNotMatched() {
        // Given
        let c1 = CardImpl(id: "c1",
                          canPlay: [IsPlayersAtLeast(2)],
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: .playersMustBeAtLeast(2))
    }
    
    func test_ThrowError_IfCardHasNoEffect() {
        // Given
        let c1 = CardImpl(id: "c1")
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: .cardHasNoEffect)
    }
    
    func test_ThrowError_IfCardFirstEffectFails() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onPlay: [EmitError(error: .playerAlreadyMaxHealth("p1"))])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: .playerAlreadyMaxHealth("p1"))
    }
}
