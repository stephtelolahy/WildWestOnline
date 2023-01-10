//
//  PlayTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
import Bang

final class PlayTests: CardTests {
    
    func test_DiscardImmediately_IfPlayed() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            let p1 = try XCTUnwrap(ctx.players["p1"])
            XCTAssertEqual(p1.hand.map(\.id), [])
            XCTAssertEqual(ctx.discard.map(\.id), ["c1"])
        }
    }
    
    func test_OutputCardEffects_IfAnyEffectDefined() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // assert
        assertIsSuccess(result) {
            let children: [Effect] = try XCTUnwrap($0.effects)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], Dummy())
        }
    }
    
    func test_ThrowsError_IfAnyRequirementNotMatched() {
        // Given
        let c1 = CardImpl(id: "c1",
                          canPlay: [IsPlayersAtLeast(count: 2)],
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // assert
        assertIsFailure(result, equalTo: .playersMustBeAtLeast(2))
    }
    
    func test_DoNotThrowsError_IfAllRequirementsMatched() {
        // Given
        let c1 = CardImpl(id: "c1",
                          canPlay: [IsPlayersAtLeast(count: 2)],
                          onPlay: [Dummy()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1], playOrder: ["p1", "p2"])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // assert
        assertIsSuccess(result)
    }
    
    func test_ThrowError_IfCardHasNoEffect() {
        // Given
        let c1 = CardImpl(id: "c1")
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // assert
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
        
        // assert
        assertIsFailure(result, equalTo: .playerAlreadyMaxHealth("p1"))
    }
}
