//
//  PlayActionTests.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
@testable import GameCards
import GameCore
import GameTesting

final class PlayActionTests: XCTestCase {
    
    func test_DiscardImmediately_IfPlayingActionCard() {
        // Given
        let c1 = CardImpl(id: "c1",
                          playMode: PlayAction(),
                          onPlay: [EffectMock()])
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
                          playMode: PlayAction(),
                          onPlay: [EffectMock()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let children = try XCTUnwrap($0.children)
            XCTAssertEqual(children.count, 1)
            assertEqual(children[0], EffectMock())
        }
    }
    
    func test_ThrowsError_IfAnyRequirementNotMatched() {
        // Given
        let c1 = CardImpl(id: "c1",
                          playMode: PlayAction(),
                          canPlay: [IsPlayersAtLeast(2)],
                          onPlay: [EffectMock()])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: GameError.playersMustBeAtLeast(2))
    }
    
    func test_ThrowError_IfCardHasNoEffect() {
        // Given
        let c1 = CardImpl(id: "c1", playMode: PlayAction())
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: GameError.cardHasNoPlayingEffect)
    }
    
    func test_ThrowError_IfCardFirstEffectFails() {
        // Given
        let c1 = CardImpl(id: "c1",
                          playMode: PlayAction(),
                          onPlay: [EffectEmitError(error: GameError.playerAlreadyMaxHealth("p1"))])
        let p1: Player = PlayerImpl(hand: [c1])
        let ctx: Game = GameImpl(players: ["p1": p1])
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsFailure(result, equalTo: GameError.playerAlreadyMaxHealth("p1"))
    }
}
