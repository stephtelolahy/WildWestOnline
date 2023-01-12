//
//  EndTurnTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class EndTurnTests: EngineTestCase {
    
    func test_SetNextTurn_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: nil)
        let p1 = PlayerImpl(health: 1, abilities: [endTurn])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2", "p3", "p1"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "endTurn"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "endTurn")),
            .success(SetTurn(player: .id("p2")))
        ])
    }
    
    func test_DiscardExcess1Card_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: nil)
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn], hand: [c1, c2])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "endTurn"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "endTurn")),
            .wait([Choose(actor: "p1", label: "c1"),
                   Choose(actor: "p1", label: "c2")],
                  input: 1),
            .success(Choose(actor: "p1", label: "c2")),
            .success(Discard(player: .id("p1"), card: .id("c2"))),
            .success(SetTurn(player: .id("p2")))
        ])
    }
    
    func test_DiscardExcess2Cards_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: nil)
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn], hand: [c1, c2, c3])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2", "p1"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "endTurn"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "endTurn")),
            .wait([Choose(actor: "p1", label: "c1"),
                   Choose(actor: "p1", label: "c2"),
                   Choose(actor: "p1", label: "c3")],
                  input: 1),
            .success(Choose(actor: "p1", label: "c2")),
            .success(Discard(player: .id("p1"), card: .id("c2"))),
            .wait([Choose(actor: "p1", label: "c1"),
                   Choose(actor: "p1", label: "c3")],
                  input: 1),
            .success(Choose(actor: "p1", label: "c3")),
            .success(Discard(player: .id("p1"), card: .id("c3"))),
            .success(SetTurn(player: .id("p2")))
        ])
    }
}
