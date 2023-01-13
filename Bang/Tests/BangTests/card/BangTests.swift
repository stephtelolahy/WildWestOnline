//
//  BangTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class BangTests: EngineTestCase {
    
    func test_DealDamage_IfPlayingBang() throws {
        // Given
        let c1 = inventory.getCard("bang", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .wait([Choose(player: "p1", label: "p2")]),
            .input(0),
            .success(Choose(player: "p1", label: "p2")),
            .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("missed"))),
            .success(Damage(player: PlayerId("p2"), value: 1))
        ])
    }
    
    func test_CannotPlayBang_IfNoPlayerReachable() throws {
        // Given
        let c1 = inventory.getCard("bang", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let ctx = GameImpl(players: ["p1": p1],
                           playOrder: ["p1"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([.error(.noPlayersAt(1))])
    }
    
    func test_CannotPlayBang_IfReachedLimitPerTurn() throws {
        // Given
        let c1 = inventory.getCard("bang", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1",
                           played: ["bang"])
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([.error(.reachedLimitPerTurn(1))])
    }
}
