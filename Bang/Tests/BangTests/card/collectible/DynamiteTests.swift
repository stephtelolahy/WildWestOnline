//
//  DynamiteTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

import XCTest
@testable import Bang

final class DynamiteTests: XCTestCase {
    
    private let inventory: Inventory = InventoryImpl()
    
    func test_DynamiteExplodes_IfFlipCardIsBetween2To9Spades() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").inPlay(inventory.getCard(.dynamite, withId: "c1")))
            .deck(CardImpl(value: "8♠️"))
        let sut = EngineImpl(ctx, queue: [SetTurn(player: PlayerId("p1"))])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(SetTurn(player: PlayerId("p1"))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.passDynamite)),
                .success(Damage(player: PlayerId("p1"), value: 3)),
                .success(Discard(player: PlayerId("p1"), card: CardId("c1")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_PassDynamite_IfFlipCardIsNotBetween2To9Spades() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").inPlay(inventory.getCard(.dynamite, withId: "c1")),
            PlayerImpl(id: "p2"))
            .deck(CardImpl(value: "9♦️"))
        let sut = EngineImpl(ctx, queue: [SetTurn(player: PlayerId("p1"))])
        
        createExpectation(
            engine: sut,
            expected: [
                .success(SetTurn(player: PlayerId("p1"))),
                .success(Trigger(actor: "p1", card: "c1")),
                .success(Luck(regex: CardRegex.passDynamite)),
                .success(PassInPlay(player: PlayerId("p1"), card: CardId("c1"), target: PlayerId("p2")))
            ])
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
