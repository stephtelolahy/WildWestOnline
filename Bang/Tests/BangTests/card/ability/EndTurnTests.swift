//
//  EndTurnTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

import XCTest
@testable import Bang

final class EndTurnTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_SetNextTurn_IfEndingTurn() throws {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .health(1)
                .ability(inventory.getCard(.endTurn, withId: "a1")),
            PlayerImpl(id: "p2"))
            .turn("p1")
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
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .health(1)
                .ability(inventory.getCard(.endTurn, withId: "a1"))
                .hand(CardImpl(id: "c1"))
                .hand(CardImpl(id: "c2")),
            PlayerImpl(id: "p2"))
            .turn("p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "a1")),
                .success(ChooseOne([Choose(actor: "p1", label: "c1"),
                                    Choose(actor: "p1", label: "c2")])),
                .input(1),
                .success(Choose(actor: "p1", label: "c2")),
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
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .health(1)
                .ability(inventory.getCard(.endTurn, withId: "a1"))
                .hand(CardImpl(id: "c1"))
                .hand(CardImpl(id: "c2"))
                .hand(CardImpl(id: "c3")),
            PlayerImpl(id: "p2"))
            .turn("p1")
        let sut = EngineImpl(ctx)
        
        createExpectation(
            engine: sut,
            expected: [
                .success(Play(actor: "p1", card: "a1")),
                .success(ChooseOne([Choose(actor: "p1", label: "c1"),
                                    Choose(actor: "p1", label: "c2"),
                                    Choose(actor: "p1", label: "c3")])),
                .input(1),
                .success(Choose(actor: "p1", label: "c2")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c2"))),
                .success(ChooseOne([Choose(actor: "p1", label: "c1"),
                                    Choose(actor: "p1", label: "c3")])),
                .input(1),
                .success(Choose(actor: "p1", label: "c3")),
                .success(Discard(player: PlayerId("p1"), card: CardId("c3"))),
                .success(SetTurn(player: PlayerId("p2")))
            ])
        
        // When
        sut.input(Play(actor: "p1", card: "a1"))
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
