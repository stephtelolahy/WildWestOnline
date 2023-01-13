//
//  EndTurnTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class EndTurnTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_SetNextTurn_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: "a1")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2", "p3", "p1"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "a1")),
                .success(SetTurn(player: PlayerId("p2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "a1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DiscardExcess1Card_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: "a1")
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn], hand: [c1, c2])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p1", "p2"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "a1")),
                .wait([Choose(player: "p1", label: "c1"),
                       Choose(player: "p1", label: "c2")]),
                .input(1),
                .success(Choose(player: "p1", label: "c2")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c2"))),
                .success(SetTurn(player: PlayerId("p2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "a1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DiscardExcess2Cards_IfEndingTurn() throws {
        // Given
        let endTurn = inventory.getCard("endTurn", withId: "a1")
        let c1 = CardImpl(id: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let p1 = PlayerImpl(health: 1, abilities: [endTurn], hand: [c1, c2, c3])
        let p2 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2],
                           playOrder: ["p2", "p1"],
                           turn: "p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "a1")),
                .wait([Choose(player: "p1", label: "c1"),
                       Choose(player: "p1", label: "c2"),
                       Choose(player: "p1", label: "c3")]),
                .input(1),
                .success(Choose(player: "p1", label: "c2")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c2"))),
                .wait([Choose(player: "p1", label: "c1"),
                       Choose(player: "p1", label: "c3")]),
                .input(1),
                .success(Choose(player: "p1", label: "c3")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c3"))),
                .success(SetTurn(player: PlayerId("p2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "a1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
