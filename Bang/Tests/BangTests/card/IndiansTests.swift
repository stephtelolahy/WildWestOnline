//
//  IndiansTests.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class IndiansTests: EngineTestCase {
    
    func test_OtherPlayersLooseHealth_IfPlayingIndians_AndNoBangCards() throws {
        // Given
        let c1 = inventory.getCard("indians", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2)
        let p3 = PlayerImpl(health: 2)
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("bang"))),
            .success(Damage(player: PlayerId("p2"), value: 1)),
            .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandMatch("bang"))),
            .success(Damage(player: PlayerId("p3"), value: 1))
        ])
    }
    
    func test_OtherPlayersDoNotLooseHealth_IfPlayingIndians_AndDiscardingBangCards() throws {
        // Given
        let c1 = inventory.getCard("indians", withId: "c1")
        let c2 = inventory.getCard("bang", withId: "c2")
        let c3 = inventory.getCard("bang", withId: "c3")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(health: 2, hand: [c2])
        let p3 = PlayerImpl(health: 2, hand: [c3])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .success(ForceDiscard(player: PlayerId("p2"), card: CardSelectHandMatch("bang"))),
            .wait([Choose(player: "p2", label: "c2"),
                   Choose(player: "p2", label: Label.pass)]),
            .input(0),
            .success(Choose(player: "p2", label: "c2")),
            .success(Discard(player: PlayerId("p2"), card: CardId("c2"))),
            .success(ForceDiscard(player: PlayerId("p3"), card: CardSelectHandMatch("bang"))),
            .wait([Choose(player: "p3", label: "c3"),
                   Choose(player: "p3", label: Label.pass)]),
            .input(0),
            .success(Choose(player: "p3", label: "c3")),
            .success(Discard(player: PlayerId("p3"), card: CardId("c3")))
        ])
    }
    
}
