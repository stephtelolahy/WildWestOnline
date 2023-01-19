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
    
    // MARK: Play action card
    
    func test_DiscardImmediately_IfPlayingActionCard() {
        // Given
        let c1 = CardImpl(id: "c1",
                          type: .action,
                          onPlay: [DummyEffect()])
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
    
    func test_OutputCardEffects_IfPlayingActionCard() {
        // Given
        let c1 = CardImpl(id: "c1",
                          onPlay: [DummyEffect()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let children = try XCTUnwrap($0.children)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], DummyEffect())
        }
    }
    
    func test_ThrowsError_IfAnyRequirementNotMatched() {
        // Given
        let c1 = CardImpl(id: "c1",
                          canPlay: [IsPlayersAtLeast(2)],
                          onPlay: [DummyEffect()])
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
        assertIsFailure(result, equalTo: .cardHasNoPlayingEffect)
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
    
    // MARK: Play equipement
    
    func test_PutInPlay_IfPlayingEquipmentCard() {
        // Given
        let c1 = CardImpl(id: "c1",
                          type: .equipment)
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), [])
            XCTAssertEqual(ctx.player("p1").inPlay.map(\.id), ["c1"])
        }
    }
    
    // TODO: Play handicap
    
    // TODO: Play ability
}
