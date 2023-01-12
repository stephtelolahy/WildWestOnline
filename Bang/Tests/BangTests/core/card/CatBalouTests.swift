//
//  CatBalouTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class CatBalouTests: EngineTestCase {
    
    func test_DiscardOthersUniqueHandCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .wait([Choose(player: "p1", label: "p2")],
                  input: 0),
            .success(Choose(player: "p1", label: "p2")),
            .wait([Choose(player: "p1", label: Label.randomHand)],
                  input: 0),
            .success(Choose(player: "p1", label: Label.randomHand)),
            .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
        ])
    }
    
    func test_DiscardOthersRandomHandCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(hand: [c2, c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .wait([Choose(player: "p1", label: "p2")],
                  input: 0),
            .success(Choose(player: "p1", label: "p2")),
            .wait([Choose(player: "p1", label: Label.randomHand)],
                  input: 0),
            .success(Choose(player: "p1", label: Label.randomHand)),
            .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
        ])
    }
    
    func test_DiscardOthersInPlayCard_IfPlayingCatBalou() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl(inPlay: [c2])
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .wait([Choose(player: "p1", label: "p2")],
                  input: 0),
            .success(Choose(player: "p1", label: "p2")),
            .wait([Choose(player: "p1", label: "c2")],
                  input: 0),
            .success(Choose(player: "p1", label: "c2")),
            .success(Discard(player: PlayerId("p2"), card: CardId("c2")))
        ])
    }
    
    func test_CannotPlayCatBalou_IfNoCardsToDiscard() throws {
        // Given
        let c1 = inventory.getCard("catBalou", withId: "c1")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        setupGame(ctx)
        
        // Phase: Play
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([.error(.playerHasNoCard("p2"))])
    }
}
